"""Tests for gesture interpreter logic (no real camera needed)."""

import time
import types
from unittest.mock import MagicMock, patch

import pytest

from core.state_machine import sm, State
from gesture.interpreter import GestureInterpreter


def _make_landmark(x=0.5, y=0.5, z=0.0):
    lm = MagicMock()
    lm.x = x
    lm.y = y
    lm.z = z
    return lm


def _make_hand(landmarks: dict):
    """landmarks: {index: MagicMock}"""
    hand = MagicMock()
    lm_list = [_make_landmark() for _ in range(21)]
    for idx, val in landmarks.items():
        lm_list[idx] = val
    hand.landmark = lm_list
    return hand


def _make_results(hands):
    r = MagicMock()
    r.multi_hand_landmarks = hands if hands else None
    return r


@pytest.fixture(autouse=True)
def set_previewing():
    sm._state = State.PREVIEWING
    yield
    sm._state = State.IDLE


def test_no_hands_resets_state():
    interp = GestureInterpreter()
    interp._baseline_pinch = 0.5
    interp.on_landmarks(_make_results(None))
    assert interp._baseline_pinch is None


def test_two_hands_emits_scale():
    interp = GestureInterpreter()
    events = []
    from core.event_bus import bus, GESTURE_SCALE
    bus.subscribe(GESTURE_SCALE, lambda e: events.append(e.payload))

    # First call sets baseline
    h1 = _make_hand({8: _make_landmark(0.3, 0.5)})
    h2 = _make_hand({8: _make_landmark(0.7, 0.5)})
    interp.on_landmarks(_make_results([h1, h2]))
    assert interp._baseline_pinch is not None

    # Second call with wider distance → scale up
    h1b = _make_hand({8: _make_landmark(0.1, 0.5)})
    h2b = _make_hand({8: _make_landmark(0.9, 0.5)})
    interp.on_landmarks(_make_results([h1b, h2b]))

    assert len(events) == 1
    assert events[0]["scale_factor"] > 1.0


def test_open_palm_confirm_after_hold():
    interp = GestureInterpreter()
    events = []
    from core.event_bus import bus, GESTURE_CONFIRM
    bus.subscribe(GESTURE_CONFIRM, lambda e: events.append(True))

    # Build an open hand: all fingertips y < their MCP y (higher on screen = lower y)
    # Wrist at bottom (high y), tips at top (low y)
    lms = {}
    # Wrist
    lms[0] = _make_landmark(0.5, 0.9)
    # Fingertip indices: 8,12,16,20 with y < MCP y (5,9,13,17)
    for tip, mcp in [(8, 5), (12, 9), (16, 13), (20, 17)]:
        lms[tip] = _make_landmark(0.5, 0.2)
        lms[mcp] = _make_landmark(0.5, 0.6)
    # Thumb: tip x farther from wrist than base
    lms[4] = _make_landmark(0.1, 0.5)   # thumb tip (far from wrist x=0.5)
    lms[2] = _make_landmark(0.35, 0.5)  # thumb base

    hand = _make_hand(lms)
    results = _make_results([hand])

    import config
    original_hold = config.CONFIRM_HOLD_S
    config.CONFIRM_HOLD_S = 0.05  # very short for test

    interp.on_landmarks(results)
    time.sleep(0.1)
    interp.on_landmarks(results)

    config.CONFIRM_HOLD_S = original_hold
    assert len(events) >= 1
