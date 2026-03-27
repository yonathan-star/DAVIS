"""
Hardware utilities for Raspberry Pi environment.

Provides helpers for display detection, camera probing, and
Raspberry Pi-specific setup.
"""

import os
import subprocess
from typing import List, Optional

from utils.logger import get_logger

log = get_logger(__name__)


def probe_cameras(max_index: int = 5) -> List[int]:
    """Return a list of working OpenCV camera indices."""
    import cv2
    found = []
    for i in range(max_index):
        cap = cv2.VideoCapture(i)
        if cap.isOpened():
            found.append(i)
            cap.release()
    log.info("Available cameras: %s", found)
    return found


def probe_audio_devices() -> None:
    """Log available sounddevice input devices."""
    try:
        import sounddevice as sd
        devices = sd.query_devices()
        log.info("Audio devices:")
        for i, d in enumerate(devices):
            if d["max_input_channels"] > 0:
                log.info("  [%d] %s (inputs: %d)", i, d["name"], d["max_input_channels"])
    except Exception as exc:
        log.warning("Could not query audio devices: %s", exc)


def check_openscad() -> bool:
    """Return True if OpenSCAD is on PATH."""
    import config
    try:
        result = subprocess.run(
            [config.OPENSCAD_BIN, "--version"],
            capture_output=True, text=True, timeout=5
        )
        version_line = (result.stdout + result.stderr).strip().split("\n")[0]
        log.info("OpenSCAD found: %s", version_line)
        return True
    except (FileNotFoundError, subprocess.TimeoutExpired):
        log.error("OpenSCAD not found. Install with: sudo apt install openscad")
        return False


def check_vosk_model() -> bool:
    """Return True if the Vosk model directory exists."""
    import config
    exists = os.path.isdir(config.VOSK_MODEL_PATH)
    if not exists:
        log.error(
            "Vosk model missing at %s\n"
            "Download from https://alphacephei.com/vosk/models\n"
            "Recommended: vosk-model-small-en-us-0.15",
            config.VOSK_MODEL_PATH,
        )
    else:
        log.info("Vosk model found: %s", config.VOSK_MODEL_PATH)
    return exists


def is_raspberry_pi() -> bool:
    """Detect if running on a Raspberry Pi."""
    try:
        with open("/proc/cpuinfo") as f:
            return "Raspberry Pi" in f.read()
    except FileNotFoundError:
        return False


def system_info() -> None:
    """Log system diagnostic info."""
    import platform
    log.info("Platform: %s %s", platform.system(), platform.machine())
    log.info("Python: %s", platform.python_version())
    log.info("Running on Pi: %s", is_raspberry_pi())
    check_openscad()
    check_vosk_model()
    probe_audio_devices()
