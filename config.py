"""
DAVIS Configuration
All hardware paths, IPs, ports, and tuning constants live here.
Edit this file before first run to match your hardware setup.
"""

import os

# ─── Paths ───────────────────────────────────────────────────────────────────

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

VOSK_MODEL_PATH = os.path.join(BASE_DIR, "models", "vosk-model-small-en-us")
STL_OUTPUT_DIR  = os.path.join(BASE_DIR, "generation", "stl_cache")
SCAD_TEMPLATES  = os.path.join(BASE_DIR, "generation", "scad_templates")
OPENSCAD_BIN    = "openscad"   # must be on PATH; or absolute e.g. "/usr/bin/openscad"

# ─── Voice ───────────────────────────────────────────────────────────────────

MIC_DEVICE_INDEX  = None   # None = system default; set to int if you have multiple USB mics
MIC_SAMPLE_RATE   = 16000  # Hz — Vosk requires 16kHz
MIC_BLOCK_SIZE    = 8000   # samples per audio block (~0.5 s)
WAKE_WORD         = "hey davis"
SILENCE_TIMEOUT_S = 1.5    # seconds of silence that end an utterance

# ─── Projection / Display ─────────────────────────────────────────────────────

PROJECTOR_DISPLAY = 1        # X11 display index (0 = primary, 1 = HDMI projector)
PROJECTOR_WIDTH   = 1280
PROJECTOR_HEIGHT  = 720
PROJECTION_FPS    = 30

# ─── Gesture Camera ───────────────────────────────────────────────────────────

CAMERA_INDEX        = 0     # OpenCV VideoCapture index
GESTURE_WIDTH       = 320
GESTURE_HEIGHT      = 240
GESTURE_FPS         = 15
CONFIRM_HOLD_S      = 2.0   # seconds to hold confirm gesture
CANCEL_HOLD_S       = 1.0

# ─── Bambu Labs Printer ───────────────────────────────────────────────────────

BAMBU_IP          = "192.168.1.100"    # local IP of your Bambu printer
BAMBU_SERIAL      = "XXXXXXXXXXXXXXX"  # 15-char serial on printer screen / box
BAMBU_ACCESS_CODE = "XXXXXXXX"         # 8-char code on printer screen
BAMBU_PORT_FTPS   = 990
BAMBU_PORT_MQTT   = 8883

# Slicer profile name to use when sending print job (must exist on the printer)
BAMBU_PROFILE     = "0.20mm Standard @BBL"

# ─── Thingiverse ─────────────────────────────────────────────────────────────

THINGIVERSE_TOKEN = ""   # Bearer token from https://www.thingiverse.com/apps/create
                          # Leave blank to use mock/offline results in gallery mode

# ─── Tuning ───────────────────────────────────────────────────────────────────

OPENSCAD_TIMEOUT_S = 60      # max seconds to wait for OpenSCAD to produce an STL
MAX_FTPS_RETRIES   = 2
MAX_MQTT_RETRIES   = 3
EVENT_DRAIN_HZ     = 60      # main loop event drain frequency
