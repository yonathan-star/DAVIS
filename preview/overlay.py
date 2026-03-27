"""
HUD overlay drawn on top of the rendered STL frame.

Draws status text, gesture hints, scale/rotation indicators,
and confirm/cancel prompts using OpenCV drawing primitives only.
"""

import cv2
import numpy as np

from core.state_machine import sm, State


FONT       = cv2.FONT_HERSHEY_SIMPLEX
FONT_SMALL = 0.55
FONT_MED   = 0.75
COLOR_WHITE = (255, 255, 255)
COLOR_GREEN = (0, 220, 120)
COLOR_RED   = (60, 60, 220)
COLOR_GRAY  = (140, 140, 140)
COLOR_YELLOW = (0, 220, 220)


def draw(frame: np.ndarray) -> np.ndarray:
    """Draw HUD elements onto frame in-place. Returns the frame."""
    state = sm.state
    ctx   = sm.context

    h, w = frame.shape[:2]

    # ── Top-left: state badge ──────────────────────────────────────────────
    state_color = {
        State.IDLE:       COLOR_GRAY,
        State.LISTENING:  COLOR_GREEN,
        State.GENERATING: COLOR_YELLOW,
        State.PREVIEWING: COLOR_GREEN,
        State.CONFIRMING: COLOR_YELLOW,
        State.PRINTING:   COLOR_YELLOW,
        State.ERROR:      COLOR_RED,
    }.get(state, COLOR_WHITE)

    label = f"DAVIS  {state.name}"
    cv2.rectangle(frame, (0, 0), (230, 32), (20, 20, 20), -1)
    cv2.putText(frame, label, (8, 22), FONT, FONT_SMALL, state_color, 1, cv2.LINE_AA)

    # ── Error message ─────────────────────────────────────────────────────
    if state == State.ERROR and sm.error_message:
        msg = sm.error_message[:80]
        cv2.rectangle(frame, (0, h//2 - 30), (w, h//2 + 10), (30, 30, 30), -1)
        cv2.putText(frame, msg, (10, h//2), FONT, FONT_SMALL, COLOR_RED, 1, cv2.LINE_AA)

    # ── Preview HUD (scale / rotation) ────────────────────────────────────
    if state in (State.PREVIEWING, State.CONFIRMING):
        scale    = ctx.get("scale", 1.0)
        rotation = ctx.get("rotation", 0.0)
        intent   = ctx.get("intent")
        obj_name = intent.object_class.upper() if intent else ""
        text_val = intent.text_content if intent and intent.text_content else ""

        # Bottom-left info panel
        panel_y = h - 90
        cv2.rectangle(frame, (0, panel_y), (320, h), (20, 20, 20), -1)
        cv2.putText(frame, f"Object: {obj_name}  {text_val}", (8, panel_y + 20),
                    FONT, FONT_SMALL, COLOR_WHITE, 1, cv2.LINE_AA)
        cv2.putText(frame, f"Scale:    {scale*100:.0f}%", (8, panel_y + 42),
                    FONT, FONT_SMALL, COLOR_GREEN, 1, cv2.LINE_AA)
        cv2.putText(frame, f"Rotation: {rotation:.0f}°", (8, panel_y + 62),
                    FONT, FONT_SMALL, COLOR_GREEN, 1, cv2.LINE_AA)

        # Bottom-right gesture hints
        hints = [
            "Both hands pinch  →  Scale",
            "One hand rotate   →  Rotate",
            "Open palm (2s)    →  Confirm",
            "Fist (1s)         →  Cancel",
        ]
        hint_x = w - 320
        for i, hint in enumerate(hints):
            cv2.putText(frame, hint, (hint_x, panel_y + 20 + i * 18),
                        FONT, 0.42, COLOR_GRAY, 1, cv2.LINE_AA)

    # ── Confirm overlay ───────────────────────────────────────────────────
    if state == State.CONFIRMING:
        cv2.rectangle(frame, (w//2 - 120, h//2 - 25), (w//2 + 120, h//2 + 25),
                      (20, 20, 20), -1)
        cv2.putText(frame, "CONFIRMING…", (w//2 - 80, h//2 + 8),
                    FONT, FONT_MED, COLOR_YELLOW, 2, cv2.LINE_AA)

    # ── Printing overlay ──────────────────────────────────────────────────
    if state == State.PRINTING:
        cv2.rectangle(frame, (w//2 - 140, h//2 - 25), (w//2 + 140, h//2 + 25),
                      (20, 20, 20), -1)
        cv2.putText(frame, "SENDING TO PRINTER…", (w//2 - 130, h//2 + 8),
                    FONT, FONT_MED, COLOR_GREEN, 2, cv2.LINE_AA)

    # ── IDLE: listening prompt ─────────────────────────────────────────────
    if state == State.IDLE:
        cv2.putText(frame, f'Say "{_wake_word()}" to begin',
                    (w//2 - 180, h - 20), FONT, FONT_SMALL, COLOR_GRAY, 1, cv2.LINE_AA)

    return frame


def _wake_word() -> str:
    import config
    return config.WAKE_WORD.title()
