"""
MediaPipe Hands tracker.

Runs inference on frames from CameraCapture and calls the interpreter
with structured landmark data.
"""

import threading
import time
from typing import Callable, Optional

import cv2
import mediapipe as mp
import numpy as np

import config
from utils.logger import get_logger

log = get_logger(__name__)

mp_hands  = mp.solutions.hands
mp_drawing = mp.solutions.drawing_utils


# Landmark indices used by interpreter
WRIST        = 0
INDEX_TIP    = 8
THUMB_TIP    = 4
MIDDLE_MCP   = 9
PINKY_TIP    = 20
RING_TIP     = 16
MIDDLE_TIP   = 12


class HandTracker:
    def __init__(self, camera, on_landmarks: Callable):
        """
        Args:
            camera: CameraCapture instance
            on_landmarks: callback(hand_results) called each frame with mediapipe results
        """
        self._camera       = camera
        self._on_landmarks = on_landmarks
        self._stop_event   = threading.Event()
        self._thread: Optional[threading.Thread] = None

    def start(self) -> None:
        self._stop_event.clear()
        self._thread = threading.Thread(
            target=self._run, daemon=True, name="hand-tracker"
        )
        self._thread.start()

    def stop(self) -> None:
        self._stop_event.set()
        if self._thread:
            self._thread.join(timeout=3)

    def _run(self) -> None:
        hands = mp_hands.Hands(
            static_image_mode=False,
            max_num_hands=2,
            min_detection_confidence=0.6,
            min_tracking_confidence=0.5,
            model_complexity=0,   # fastest; use 1 on Pi 4 8GB if you want more accuracy
        )

        log.info("HandTracker running")
        interval = 1.0 / config.GESTURE_FPS

        while not self._stop_event.is_set():
            frame = self._camera.get_frame()
            if frame is None:
                time.sleep(0.05)
                continue

            # Flip so it mirrors natural hand movement
            frame_rgb = cv2.cvtColor(cv2.flip(frame, 1), cv2.COLOR_BGR2RGB)
            frame_rgb.flags.writeable = False
            results = hands.process(frame_rgb)
            frame_rgb.flags.writeable = True

            self._on_landmarks(results)
            time.sleep(interval)

        hands.close()
        log.info("HandTracker stopped")
