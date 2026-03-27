"""
DAVIS — Desktop Automated Voice-driven Instant Studio
Entry point.

Boots all subsystems, wires event subscriptions, and runs the main loop.
Press Ctrl+C to shut down cleanly.
"""

import queue
import signal
import sys
import time

from utils.logger import get_logger
from utils.hardware import system_info

log = get_logger("davis.main")


def _setup_signal_handlers(shutdown_flag: list) -> None:
    def _handler(sig, frame):
        log.info("Shutdown signal received")
        shutdown_flag[0] = True

    signal.signal(signal.SIGINT,  _handler)
    signal.signal(signal.SIGTERM, _handler)


def main() -> int:
    log.info("╔══════════════════════════════════════╗")
    log.info("║         DAVIS  v0.1.0                ║")
    log.info("╚══════════════════════════════════════╝")

    system_info()

    # ── Audio pipeline queue ──────────────────────────────────────────────
    audio_queue: queue.Queue = queue.Queue()

    # ── Instantiate all modules ───────────────────────────────────────────
    # Import here (after logger is init'd) so module-level singletons work
    from core.event_bus import bus, FAULT, SHUTDOWN, GESTURE_SCALE, GESTURE_ROTATE
    from core.state_machine import sm, State

    from voice.listener    import MicListener
    from voice.recognizer  import VoskRecognizer
    from voice.intent_parser import IntentParser

    from generation.generator import Generator

    from gesture.camera      import CameraCapture
    from gesture.tracker     import HandTracker
    from gesture.interpreter import GestureInterpreter

    from preview.projector import Projector
    from printer.bambu_client import BambuClient

    # Instantiate (subscribes to EventBus as a side effect)
    intent_parser = IntentParser()
    generator     = Generator()
    gesture_interp = GestureInterpreter()
    bambu         = BambuClient()

    # ── Wire gesture scale/rotate into state machine context ──────────────
    def on_scale(event):
        if sm.state in (State.PREVIEWING, State.CONFIRMING):
            factor = event.payload.get("scale_factor", 1.0)
            sm.context["scale"] = max(0.1, min(10.0, sm.context["scale"] * factor))

    def on_rotate(event):
        if sm.state in (State.PREVIEWING, State.CONFIRMING):
            sm.context["rotation"] = (sm.context["rotation"] + event.payload.get("delta_deg", 0)) % 360

    bus.subscribe(GESTURE_SCALE,  on_scale)
    bus.subscribe(GESTURE_ROTATE, on_rotate)

    # ── Wire wake word: IDLE → LISTENING ──────────────────────────────────
    from core.event_bus import VOICE_UTTERANCE_READY
    import config

    def on_utterance_wake(event):
        text: str = event.payload.get("text", "").lower()
        if sm.state == State.IDLE and config.WAKE_WORD.lower() in text:
            sm.transition(State.LISTENING, reason="wake word")

    bus.subscribe(VOICE_UTTERANCE_READY, on_utterance_wake)

    # ── Auto-return from ERROR after 5 seconds ────────────────────────────
    def on_fault(_event):
        def _reset():
            time.sleep(5)
            if sm.state == State.ERROR:
                sm.reset_context()
                sm.transition(State.IDLE, reason="error timeout")
        import threading
        threading.Thread(target=_reset, daemon=True).start()

    bus.subscribe(FAULT, on_fault)

    # ── Start hardware threads ────────────────────────────────────────────
    mic       = MicListener(audio_queue)
    recognizer = VoskRecognizer(audio_queue)
    camera    = CameraCapture()
    tracker   = HandTracker(camera, gesture_interp.on_landmarks)
    projector = Projector()

    try:
        recognizer.load_model()
    except FileNotFoundError as exc:
        log.warning("%s\nStarting without voice recognition.", exc)

    mic.start()
    recognizer.start()
    camera.start()
    tracker.start()
    projector.start()

    log.info("DAVIS ready. Say %r to begin.", config.WAKE_WORD)

    # ── Main loop ─────────────────────────────────────────────────────────
    shutdown_flag = [False]
    _setup_signal_handlers(shutdown_flag)

    tick_interval = 1.0 / config.EVENT_DRAIN_HZ

    while not shutdown_flag[0]:
        bus.drain()
        time.sleep(tick_interval)

    # ── Graceful shutdown ─────────────────────────────────────────────────
    log.info("Shutting down…")
    bus.publish(SHUTDOWN)
    bus.drain()

    mic.stop()
    recognizer.stop()
    tracker.stop()
    camera.stop()
    projector.stop()

    log.info("DAVIS stopped.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
