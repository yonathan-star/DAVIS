"""
EventBus — lightweight pub/sub dispatcher backed by a thread-safe queue.

Producers push events from any thread.
The main loop calls bus.drain() each tick; delivery runs on the main thread,
so handlers never need locks.
"""

import queue
import threading
from dataclasses import dataclass, field
from typing import Any, Callable, Dict, List


# ─── Event topic constants ────────────────────────────────────────────────────

VOICE_UTTERANCE_READY = "voice.utterance_ready"
INTENT_PARSED         = "voice.intent_parsed"
STL_READY             = "generation.stl_ready"
GESTURE_SCALE         = "gesture.scale"
GESTURE_ROTATE        = "gesture.rotate"
GESTURE_CONFIRM       = "gesture.confirm"
GESTURE_CANCEL        = "gesture.cancel"
PRINT_STARTED         = "printer.started"
PRINT_COMPLETE        = "printer.complete"
FAULT                 = "system.fault"
STATE_CHANGED         = "system.state_changed"
SHUTDOWN              = "system.shutdown"


@dataclass
class Event:
    topic: str
    payload: Any = None


class EventBus:
    def __init__(self):
        self._queue: queue.Queue = queue.Queue()
        self._subscribers: Dict[str, List[Callable]] = {}
        self._lock = threading.Lock()

    def subscribe(self, topic: str, handler: Callable[[Event], None]) -> None:
        with self._lock:
            self._subscribers.setdefault(topic, []).append(handler)

    def publish(self, topic: str, payload: Any = None) -> None:
        """Thread-safe. Can be called from any thread."""
        self._queue.put(Event(topic=topic, payload=payload))

    def drain(self) -> None:
        """Call from the main thread each loop tick to deliver queued events."""
        try:
            while True:
                event = self._queue.get_nowait()
                with self._lock:
                    handlers = list(self._subscribers.get(event.topic, []))
                for handler in handlers:
                    try:
                        handler(event)
                    except Exception as exc:
                        # Avoid crashing the main loop on a bad handler
                        from utils.logger import get_logger
                        get_logger(__name__).exception(
                            "Handler %s raised on topic %s: %s", handler, event.topic, exc
                        )
        except queue.Empty:
            pass


# Module-level singleton — import and use directly
bus = EventBus()
