"""
Gesture interpreter.

Translates MediaPipe hand landmark positions into DAVIS gesture events:
  GESTURE_SCALE   — two hands, pinch distance changing
  GESTURE_ROTATE  — one hand, palm rotating
  GESTURE_CONFIRM — open palm held for CONFIRM_HOLD_S seconds
  GESTURE_CANCEL  — closed fist held for CANCEL_HOLD_S seconds
"""

import math
import time
from typing import Optional

import config
from core.event_bus import bus, GESTURE_SCALE, GESTURE_ROTATE, GESTURE_CONFIRM, GESTURE_CANCEL
from core.state_machine import sm, State
from gesture.tracker import (
    WRIST, THUMB_TIP, INDEX_TIP, MIDDLE_TIP, RING_TIP, PINKY_TIP, MIDDLE_MCP
)
from utils.logger import get_logger

log = get_logger(__name__)

ACTIVE_STATES = {State.PREVIEWING, State.CONFIRMING}


class GestureInterpreter:
    def __init__(self):
        self._baseline_pinch: Optional[float] = None
        self._confirm_start:  Optional[float] = None
        self._cancel_start:   Optional[float] = None
        self._last_angle:     Optional[float] = None

    def on_landmarks(self, results) -> None:
        """Called by HandTracker each frame with mediapipe Results."""
        if sm.state not in ACTIVE_STATES:
            self._reset()
            return

        if not results.multi_hand_landmarks:
            self._reset()
            return

        hands = results.multi_hand_landmarks

        if len(hands) == 2:
            self._handle_two_hands(hands)
        elif len(hands) == 1:
            self._handle_one_hand(hands[0])

    def _handle_two_hands(self, hands) -> None:
        """Two hands → scale gesture via inter-hand pinch distance."""
        self._confirm_start = None
        self._cancel_start  = None
        self._last_angle    = None

        # Use index fingertips of each hand as the two reference points
        p1 = hands[0].landmark[INDEX_TIP]
        p2 = hands[1].landmark[INDEX_TIP]
        dist = math.hypot(p1.x - p2.x, p1.y - p2.y)

        if self._baseline_pinch is None:
            self._baseline_pinch = dist
            return

        if self._baseline_pinch < 1e-6:
            return

        scale_factor = dist / self._baseline_pinch
        # Dampen: only emit if the change is noticeable
        if abs(scale_factor - 1.0) > 0.02:
            bus.publish(GESTURE_SCALE, {"scale_factor": scale_factor})
            self._baseline_pinch = dist  # rolling baseline prevents runaway

    def _handle_one_hand(self, hand) -> None:
        """One hand → detect rotate, confirm (open palm), or cancel (fist)."""
        self._baseline_pinch = None

        lm = hand.landmark

        # ── Rotation: angle of wrist → middle MCP vector ──────────────────
        wrist = lm[WRIST]
        mid   = lm[MIDDLE_MCP]
        angle = math.degrees(math.atan2(mid.y - wrist.y, mid.x - wrist.x))

        if self._last_angle is not None:
            delta = angle - self._last_angle
            # Unwrap large jumps
            if delta > 90:  delta -= 180
            if delta < -90: delta += 180
            if abs(delta) > 1.5:  # dead zone
                bus.publish(GESTURE_ROTATE, {"delta_deg": delta})
        self._last_angle = angle

        # ── Open palm check (all fingertips above their MCP = extended) ───
        tips  = [INDEX_TIP, MIDDLE_TIP, RING_TIP, PINKY_TIP]
        mcps  = [5, 9, 13, 17]
        open_count = sum(1 for t, m in zip(tips, mcps) if lm[t].y < lm[m].y)
        # Thumb: tip x farther from wrist than base
        thumb_open = abs(lm[THUMB_TIP].x - lm[WRIST].x) > abs(lm[4].x - lm[2].x)
        is_open = open_count >= 3 and thumb_open

        # ── Fist check ────────────────────────────────────────────────────
        closed_count = sum(1 for t, m in zip(tips, mcps) if lm[t].y > lm[m].y)
        is_fist = closed_count == 4

        # ── Timed confirm ─────────────────────────────────────────────────
        now = time.monotonic()
        if is_open:
            self._cancel_start = None
            if self._confirm_start is None:
                self._confirm_start = now
            elif now - self._confirm_start >= config.CONFIRM_HOLD_S:
                log.info("Gesture: CONFIRM")
                bus.publish(GESTURE_CONFIRM)
                self._confirm_start = None
        else:
            self._confirm_start = None

        # ── Timed cancel ──────────────────────────────────────────────────
        if is_fist:
            self._confirm_start = None
            if self._cancel_start is None:
                self._cancel_start = now
            elif now - self._cancel_start >= config.CANCEL_HOLD_S:
                log.info("Gesture: CANCEL")
                bus.publish(GESTURE_CANCEL)
                self._cancel_start = None
        else:
            self._cancel_start = None

    def _reset(self) -> None:
        self._baseline_pinch = None
        self._confirm_start  = None
        self._cancel_start   = None
        self._last_angle     = None
