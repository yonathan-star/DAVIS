"""
DAVIS State Machine

Single authority on what the system is currently doing.
All modules read the current state before acting and publish state-change
requests via the EventBus rather than changing state directly.
"""

from enum import Enum, auto
from typing import Optional

from core.event_bus import bus, STATE_CHANGED, FAULT, SHUTDOWN
from utils.logger import get_logger

log = get_logger(__name__)


class State(Enum):
    IDLE       = auto()  # mic active, waiting for wake word
    LISTENING  = auto()  # full utterance capture in progress
    GENERATING = auto()  # OpenSCAD subprocess running
    PREVIEWING = auto()  # STL projected on desk, gesture loop active
    CONFIRMING = auto()  # user holding confirm gesture
    PRINTING   = auto()  # FTPS upload + MQTT dispatch
    ERROR      = auto()  # fault display, returns to IDLE after timeout
    SHUTDOWN   = auto()  # clean exit requested


# Valid transitions: source_state → set of allowed destination states
_TRANSITIONS: dict = {
    State.IDLE:       {State.LISTENING, State.SHUTDOWN},
    State.LISTENING:  {State.GENERATING, State.IDLE, State.ERROR},
    State.GENERATING: {State.PREVIEWING, State.IDLE, State.ERROR},
    State.PREVIEWING: {State.CONFIRMING, State.IDLE, State.ERROR},
    State.CONFIRMING: {State.PRINTING, State.PREVIEWING, State.ERROR},
    State.PRINTING:   {State.IDLE, State.ERROR},
    State.ERROR:      {State.IDLE, State.SHUTDOWN},
    State.SHUTDOWN:   set(),
}


class StateMachine:
    def __init__(self):
        self._state: State = State.IDLE
        self._error_message: Optional[str] = None
        # Context shared across states (current STL path, current scale/rotation)
        self.context: dict = {
            "stl_path": None,
            "scale": 1.0,
            "rotation": 0.0,
            "intent": None,
        }

    @property
    def state(self) -> State:
        return self._state

    @property
    def error_message(self) -> Optional[str]:
        return self._error_message

    def transition(self, new_state: State, reason: str = "") -> bool:
        allowed = _TRANSITIONS.get(self._state, set())
        if new_state not in allowed:
            log.warning(
                "Rejected transition %s → %s (%s)",
                self._state.name, new_state.name, reason
            )
            return False
        old = self._state
        self._state = new_state
        log.info("State: %s → %s  %s", old.name, new_state.name, f"({reason})" if reason else "")
        bus.publish(STATE_CHANGED, {"from": old, "to": new_state, "reason": reason})
        return True

    def fault(self, message: str) -> None:
        self._error_message = message
        log.error("FAULT: %s", message)
        bus.publish(FAULT, {"message": message})
        self.transition(State.ERROR, reason=message)

    def reset_context(self) -> None:
        self.context = {
            "stl_path": None,
            "scale": 1.0,
            "rotation": 0.0,
            "intent": None,
        }


# Module-level singleton
sm = StateMachine()
