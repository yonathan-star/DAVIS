"""
Generation dispatcher.

Receives INTENT_PARSED events, routes to text_gen or shape_gen,
and emits STL_READY or FAULT.
"""

import threading

from core.event_bus import bus, INTENT_PARSED, STL_READY, FAULT
from core.state_machine import sm, State
from generation import text_gen, shape_gen
from voice.intent_parser import Intent
from utils.logger import get_logger

log = get_logger(__name__)

TEXT_CLASSES  = {"label", "nameplate", "tag", "sign", "plate", "badge"}
SHAPE_CLASSES = {"box", "cube", "bracket", "hook", "knob", "cylinder",
                 "ring", "stand", "holder", "replacement"}


class Generator:
    def __init__(self):
        bus.subscribe(INTENT_PARSED, self._on_intent)

    def _on_intent(self, event) -> None:
        intent: Intent = event.payload
        if not isinstance(intent, Intent):
            log.error("Expected Intent payload, got %s", type(intent))
            return

        sm.context["intent"] = intent
        if not sm.transition(State.GENERATING, reason=f"intent={intent.object_class}"):
            return

        # Run OpenSCAD in a thread so the main loop stays responsive
        thread = threading.Thread(
            target=self._generate,
            args=(intent,),
            daemon=True,
            name="generator",
        )
        thread.start()

    def _generate(self, intent: Intent) -> None:
        try:
            obj_class = intent.object_class

            if obj_class in TEXT_CLASSES:
                stl_path = text_gen.generate(intent)
            elif obj_class in SHAPE_CLASSES:
                stl_path = shape_gen.generate(intent)
            else:
                # Unknown — fall back to shape_gen box
                log.warning("Unknown object class %r, falling back to box", obj_class)
                stl_path = shape_gen.generate(intent)

            sm.context["stl_path"] = stl_path
            sm.context["scale"]    = 1.0
            sm.context["rotation"] = 0.0
            bus.publish(STL_READY, {"stl_path": stl_path, "intent": intent})

        except Exception as exc:
            log.exception("Generation failed: %s", exc)
            sm.fault(str(exc))
