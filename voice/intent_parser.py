"""
Rule-based intent parser.

Converts raw recognized text into a structured Intent dataclass.
No LLM, no network — pure regex + keyword matching.

Supported object classes:
    label | nameplate | tag | box | bracket | hook | knob | cylinder | replacement
"""

import re
from dataclasses import dataclass, field
from typing import Optional

import config
from core.event_bus import bus, VOICE_UTTERANCE_READY, INTENT_PARSED
from core.state_machine import sm, State
from utils.logger import get_logger

log = get_logger(__name__)


# ─── Intent dataclass ─────────────────────────────────────────────────────────

@dataclass
class Intent:
    object_class: str              # e.g. "label", "nameplate", "box"
    text_content: Optional[str]    # text to emboss/engrave, if applicable
    width_mm: Optional[float]
    height_mm: Optional[float]
    depth_mm: Optional[float]
    font_size: Optional[float]
    raw: str                       # original utterance


# ─── Keyword maps ─────────────────────────────────────────────────────────────

TEXT_OBJECTS  = {"label", "nameplate", "tag", "sign", "plate", "badge"}
SHAPE_OBJECTS = {"box", "cube", "bracket", "hook", "knob", "cylinder", "ring", "stand", "holder", "replacement"}

# Phrases that introduce the text content
TEXT_CUES = [
    r"that says?\s+[\"']?(.+?)[\"']?\s*(?:with|in|at|$)",
    r"reading\s+[\"']?(.+?)[\"']?\s*(?:with|in|at|$)",
    r"labeled\s+[\"']?(.+?)[\"']?\s*(?:with|in|at|$)",
    r"saying\s+[\"']?(.+?)[\"']?\s*(?:with|in|at|$)",
    r"with the (?:text|words?)\s+[\"']?(.+?)[\"']?\s*$",
    r'"(.+?)"',   # anything in double quotes
    r"'(.+?)'",   # anything in single quotes
]

UNIT_TO_MM = {
    "mm":          1.0,
    "millimeter":  1.0,
    "millimeters": 1.0,
    "cm":          10.0,
    "centimeter":  10.0,
    "centimeters": 10.0,
    "in":          25.4,
    "inch":        25.4,
    "inches":      25.4,
}

# Regex to find dimension mentions like "5 cm", "30mm", "2 inches"
DIM_PATTERN = re.compile(
    r"(\d+(?:\.\d+)?)\s*(" + "|".join(UNIT_TO_MM.keys()) + r")",
    re.IGNORECASE,
)

WAKE_WORD = config.WAKE_WORD.lower()


# ─── Parser ───────────────────────────────────────────────────────────────────

class IntentParser:
    def __init__(self):
        bus.subscribe(VOICE_UTTERANCE_READY, self._on_utterance)

    def _on_utterance(self, event) -> None:
        text: str = event.payload.get("text", "").lower().strip()

        # Strip wake word if present at the start
        if text.startswith(WAKE_WORD):
            text = text[len(WAKE_WORD):].strip()

        # Only parse when IDLE (wake word triggers) or LISTENING
        if sm.state not in (State.IDLE, State.LISTENING):
            log.debug("Ignoring utterance in state %s", sm.state.name)
            return

        intent = self._parse(text)
        if intent is None:
            log.info("No actionable intent found in: %r", text)
            return

        log.info("Intent parsed: class=%s text=%r dims=(%s,%s,%s)",
                 intent.object_class, intent.text_content,
                 intent.width_mm, intent.height_mm, intent.depth_mm)
        bus.publish(INTENT_PARSED, intent)

    def _parse(self, text: str) -> Optional[Intent]:
        obj_class = self._extract_object_class(text)
        if obj_class is None:
            return None

        text_content = self._extract_text_content(text)
        dims = self._extract_dimensions(text)

        return Intent(
            object_class=obj_class,
            text_content=text_content,
            width_mm=dims[0],
            height_mm=dims[1],
            depth_mm=dims[2],
            font_size=None,
            raw=text,
        )

    def _extract_object_class(self, text: str) -> Optional[str]:
        for word in TEXT_OBJECTS:
            if word in text:
                return word
        for word in SHAPE_OBJECTS:
            if word in text:
                return word
        return None

    def _extract_text_content(self, text: str) -> Optional[str]:
        for pattern in TEXT_CUES:
            m = re.search(pattern, text, re.IGNORECASE)
            if m:
                return m.group(1).strip()
        return None

    def _extract_dimensions(self, text: str) -> tuple:
        """Return (width_mm, height_mm, depth_mm) — any may be None."""
        matches = DIM_PATTERN.findall(text)
        dims = [float(val) * UNIT_TO_MM[unit.lower()] for val, unit in matches]
        w = dims[0] if len(dims) > 0 else None
        h = dims[1] if len(dims) > 1 else None
        d = dims[2] if len(dims) > 2 else None
        return w, h, d
