"""
Microphone capture loop.

Opens the USB microphone via sounddevice and streams 16kHz mono PCM chunks
into a thread-safe queue consumed by recognizer.py.
"""

import queue
import threading

import sounddevice as sd
import numpy as np

import config
from utils.logger import get_logger

log = get_logger(__name__)


class MicListener:
    """Captures audio from the configured mic and feeds chunks to a queue."""

    def __init__(self, audio_queue: queue.Queue):
        self._queue = audio_queue
        self._stop_event = threading.Event()
        self._thread: threading.Thread | None = None

    def start(self) -> None:
        self._stop_event.clear()
        self._thread = threading.Thread(target=self._run, daemon=True, name="mic-listener")
        self._thread.start()
        log.info("MicListener started (device=%s, rate=%d)", config.MIC_DEVICE_INDEX, config.MIC_SAMPLE_RATE)

    def stop(self) -> None:
        self._stop_event.set()
        if self._thread:
            self._thread.join(timeout=3)

    def _run(self) -> None:
        def callback(indata: np.ndarray, frames: int, time, status):
            if status:
                log.warning("sounddevice status: %s", status)
            # Convert float32 → int16 PCM bytes (Vosk expects bytes)
            pcm = (indata[:, 0] * 32767).astype(np.int16).tobytes()
            self._queue.put(pcm)

        try:
            with sd.InputStream(
                samplerate=config.MIC_SAMPLE_RATE,
                blocksize=config.MIC_BLOCK_SIZE,
                device=config.MIC_DEVICE_INDEX,
                channels=1,
                dtype="float32",
                callback=callback,
            ):
                log.debug("Audio stream open")
                self._stop_event.wait()
        except Exception as exc:
            log.exception("MicListener error: %s", exc)
