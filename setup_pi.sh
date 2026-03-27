#!/usr/bin/env bash
# DAVIS Raspberry Pi setup script
# Run once after flashing Pi OS Bookworm (64-bit recommended)
# Usage: bash setup_pi.sh

set -e

echo "=== DAVIS Pi Setup ==="

# ── System packages ──────────────────────────────────────────────────────────
sudo apt update
sudo apt install -y \
    openscad \
    python3-pip \
    python3-venv \
    libatlas-base-dev \
    libhdf5-dev \
    libopenblas-dev \
    python3-dev \
    portaudio19-dev \
    libjpeg-dev \
    libpng-dev \
    libgl1-mesa-glx \
    libglib2.0-0 \
    v4l-utils \
    libgeos-dev \
    fonts-liberation \
    fonts-dejavu

# ── Python virtual environment ───────────────────────────────────────────────
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip wheel

# ── Python dependencies ───────────────────────────────────────────────────────
pip install -r requirements.txt
# Triangulation engine for trimesh polygon extrusion
pip install mapbox-earcut

# ── Download Vosk model ───────────────────────────────────────────────────────
MODEL_DIR="models"
MODEL_NAME="vosk-model-small-en-us-0.15"
MODEL_URL="https://alphacephei.com/vosk/models/${MODEL_NAME}.zip"

mkdir -p "$MODEL_DIR"
if [ ! -d "${MODEL_DIR}/vosk-model-small-en-us" ]; then
    echo "Downloading Vosk model…"
    wget -q --show-progress -O /tmp/vosk_model.zip "$MODEL_URL"
    unzip -q /tmp/vosk_model.zip -d "$MODEL_DIR"
    mv "${MODEL_DIR}/${MODEL_NAME}" "${MODEL_DIR}/vosk-model-small-en-us"
    rm /tmp/vosk_model.zip
    echo "Vosk model installed."
else
    echo "Vosk model already present."
fi

# ── Auto-start on boot (optional, comment out if not desired) ─────────────────
DAVIS_DIR="$(pwd)"
SERVICE_FILE="/etc/systemd/system/davis.service"
sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=DAVIS Fabrication Assistant
After=network.target sound.target

[Service]
Type=simple
User=pi
WorkingDirectory=${DAVIS_DIR}
ExecStart=${DAVIS_DIR}/venv/bin/python ${DAVIS_DIR}/main.py
Restart=on-failure
RestartSec=5
Environment=DISPLAY=:0
Environment=LOG_LEVEL=INFO

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable davis.service
echo "DAVIS service installed. Start with: sudo systemctl start davis"

echo ""
echo "=== Setup complete ==="
echo "Before first run, edit config.py and set:"
echo "  BAMBU_IP, BAMBU_SERIAL, BAMBU_ACCESS_CODE"
echo "Then run: python main.py"
