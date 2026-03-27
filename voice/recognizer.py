"""
Offline speech recognition using Vosk.

Processes PCM audio chunks from the mic queue and emits
VOICE_UTTERANCE_READY events when end-of-speech is detected.
"""

import json
import os
import queue
import threading

from vosk import Model, KaldiRecognizer

import config
from core.event_bus import bus, VOICE_UTTERANCE_READY
from utils.logger import get_logger

log = get_logger(__name__)


class VoskRecognizer:
    def __init__(self, audio_queue: queue.Queue):
        self._audio_queue = audio_queue
        self._stop_event = threading.Event()
        self._thread: threading.Thread | None = None
        self._model: Model | None = None
        self._rec: KaldiRecognizer | None = None

    def load_model(self) -> None:
        if not os.path.isdir(config.VOSK_MODEL_PATH):
            raise FileNotFoundError(
                f"Vosk model not found at {config.VOSK_MODEL_PATH}\n"
                "Download from https://alphacephei.com/vosk/models and extract to models/"
            )
        log.info("Loading Vosk model from %s …", config.VOSK_MODEL_PATH)
        self._model = Model(config.VOSK_MODEL_PATH)
        self._rec = KaldiRecognizer(self._model, config.MIC_SAMPLE_RATE)
        log.info("Vosk model loaded")

    def start(self) -> None:
        if self._model is None:
            self.load_model()
        self._stop_event.clear()
        self._thread = threading.Thread(target=self._run, daemon=True, name="vosk-recognizer")
        self._thread.start()

    def stop(self) -> None:
        self._stop_event.set()
        if self._thread:
            self._thread.join(timeout=3)

    def _run(self) -> None:
        log.info("VoskRecognizer running")
        while not self._stop_event.is_set():
            try:
                chunk = self._audio_queue.get(timeout=0.5)
            except queue.Empty:
                continue

            if self._rec.AcceptWaveform(chunk):
                result = json.loads(self._rec.Result())
                text = result.get("text", "").strip()
                if text:
                    log.info("Recognized: %r", text)
                    bus.publish(VOICE_UTTERANCE_READY, {"text": text})
            else:
                # Partial result — useful for streaming display if desired
                partial = json.loads(self._rec.PartialResult())
                partial_text = partial.get("partial", "")
                if partial_text:
                    log.debug("Partial: %r", partial_text)
