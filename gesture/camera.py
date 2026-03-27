"""
Camera capture loop.

Runs cv2.VideoCapture in a background thread and publishes raw frames
to a shared deque (maxlen=1) so gesture processing always gets the
freshest frame without queueing up.
"""

import threading
from collections import deque
from typing import Optional

import cv2
import numpy as np

import config
from utils.logger import get_logger

log = get_logger(__name__)


class CameraCapture:
    def __init__(self):
        self.frame_deque: deque = deque(maxlen=1)
        self._stop_event = threading.Event()
        self._thread: Optional[threading.Thread] = None

    def start(self) -> None:
        self._stop_event.clear()
        self._thread = threading.Thread(
            target=self._run, daemon=True, name="camera-capture"
        )
        self._thread.start()

    def stop(self) -> None:
        self._stop_event.set()
        if self._thread:
            self._thread.join(timeout=3)

    def get_frame(self) -> Optional[np.ndarray]:
        """Return the most recent frame, or None if none available."""
        try:
            return self.frame_deque[-1]
        except IndexError:
            return None

    def _run(self) -> None:
        cap = cv2.VideoCapture(config.CAMERA_INDEX)
        if not cap.isOpened():
            log.error("Cannot open camera index %d", config.CAMERA_INDEX)
            return

        cap.set(cv2.CAP_PROP_FRAME_WIDTH,  config.GESTURE_WIDTH)
        cap.set(cv2.CAP_PROP_FRAME_HEIGHT, config.GESTURE_HEIGHT)
        cap.set(cv2.CAP_PROP_FPS,          config.GESTURE_FPS)

        log.info("Camera capture started (index=%d, %dx%d @ %dfps)",
                 config.CAMERA_INDEX, config.GESTURE_WIDTH,
                 config.GESTURE_HEIGHT, config.GESTURE_FPS)

        while not self._stop_event.is_set():
            ret, frame = cap.read()
            if ret:
                self.frame_deque.append(frame)
            else:
                log.warning("Camera read failed — retrying")

        cap.release()
        log.info("Camera capture stopped")
