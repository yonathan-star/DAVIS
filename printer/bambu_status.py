"""
DAVIS Bambu Status

Connects to the Bambu Labs printer via MQTT (port 8883, TLS) and reads
live status: printer model, AMS filament slots, external spool, online state.

Usage
-----
    status = BambuStatus()
    status.connect()                 # non-blocking, background thread
    ...
    info = status.snapshot()         # dict with printer_model, filaments, online
    status.disconnect()

The snapshot is updated every time the printer publishes a report.
If the printer is unreachable, snapshot() returns sensible defaults.
"""

from __future__ import annotations

import json
import ssl
import threading
import time
from dataclasses import dataclass, field
from typing import Optional

try:
    import paho.mqtt.client as mqtt
    _MQTT = True
except ImportError:
    _MQTT = False


# ─── Serial → model name ──────────────────────────────────────────────────────

_SERIAL_PREFIXES = {
    "00M": "Bambu X1C",
    "00W": "Bambu P1S",
    "030": "Bambu A1",
    "039": "Bambu A1 Mini",
    "BL" : "Bambu Lab Printer",
}

def _model_from_serial(serial: str) -> str:
    for prefix, name in _SERIAL_PREFIXES.items():
        if serial.upper().startswith(prefix):
            return name
    return "Bambu Printer"


# ─── Filament slot ────────────────────────────────────────────────────────────

@dataclass
class FilamentSlot:
    label: str          # e.g. "AMS 1-A" or "External"
    material: str       # e.g. "PLA", "PETG"
    color_hex: str      # e.g. "FF0000"
    brand: str          # e.g. "Bambu"

    def display(self) -> str:
        """Short string for UI dropdown."""
        parts = [self.label, self.material]
        if self.brand and self.brand.lower() not in ("", "unknown", "generic"):
            parts.append(self.brand)
        return "  ".join(parts)


# ─── Snapshot ─────────────────────────────────────────────────────────────────

@dataclass
class PrinterSnapshot:
    online:        bool              = False
    printer_model: str               = "Bambu Printer"
    state:         str               = "UNKNOWN"    # IDLE, RUNNING, PAUSE, etc.
    filaments:     list[FilamentSlot] = field(default_factory=list)
    bed_temp:      float             = 0.0
    nozzle_temp:   float             = 0.0
    last_updated:  float             = 0.0


# ─── BambuStatus ─────────────────────────────────────────────────────────────

class BambuStatus:
    def __init__(self, ip: str, serial: str, access_code: str, port: int = 8883):
        self.ip          = ip
        self.serial      = serial
        self.access_code = access_code
        self.port        = port
        self._snap       = PrinterSnapshot(printer_model=_model_from_serial(serial))
        self._lock       = threading.Lock()
        self._client     = None
        self._connected  = False

    # ── Public API ────────────────────────────────────────────────────────────

    def connect(self):
        """Start background MQTT connection. Non-blocking."""
        if not _MQTT:
            print("[bambu_status] paho-mqtt not installed")
            return
        t = threading.Thread(target=self._run, daemon=True)
        t.start()

    def disconnect(self):
        if self._client:
            try:
                self._client.disconnect()
            except Exception:
                pass

    def publish_command(self, payload: dict) -> bool:
        """Publish a command to device/{serial}/request over the live MQTT connection.

        Returns True on success, False if not connected.
        """
        if not self._client or not self._connected:
            return False
        topic = f"device/{self.serial}/request"
        result = self._client.publish(topic, json.dumps(payload), qos=1)
        return result.rc == 0   # 0 == MQTT_ERR_SUCCESS

    def snapshot(self) -> PrinterSnapshot:
        """Return a copy of the latest printer state."""
        with self._lock:
            import copy
            return copy.copy(self._snap)

    def is_online(self) -> bool:
        return self._connected

    # ── MQTT internals ────────────────────────────────────────────────────────

    def _run(self):
        # paho-mqtt 2.x uses CallbackAPIVersion; fall back for older versions
        try:
            client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION1,
                                 client_id="DAVIS_status")
        except Exception:
            client = mqtt.Client(client_id="DAVIS_status")

        client.username_pw_set("bblp", self.access_code)

        ctx = ssl.create_default_context()
        ctx.check_hostname = False
        ctx.verify_mode    = ssl.CERT_NONE
        client.tls_set_context(ctx)

        client.on_connect    = self._on_connect
        client.on_disconnect = self._on_disconnect
        client.on_message    = self._on_message

        self._client = client
        try:
            client.connect(self.ip, self.port, keepalive=60)
            client.loop_forever()
        except Exception as exc:
            print(f"[bambu_status] MQTT connection failed: {exc}")
            self._connected = False

    def _on_connect(self, client, userdata, flags, rc, *args):
        if rc == 0:
            self._connected = True
            topic = f"device/{self.serial}/report"
            client.subscribe(topic)
            print(f"[bambu_status] Connected, subscribed to {topic}")
            with self._lock:
                self._snap.online = True
                self._snap.printer_model = _model_from_serial(self.serial)
        else:
            print(f"[bambu_status] MQTT connect failed rc={rc}")
            self._connected = False

    def _on_disconnect(self, client, userdata, rc, *args):
        self._connected = False
        with self._lock:
            self._snap.online = False
        print(f"[bambu_status] Disconnected rc={rc}")

    def _on_message(self, client, userdata, msg):
        try:
            data = json.loads(msg.payload.decode())
        except Exception:
            return

        print_data = data.get("print", {})
        if not print_data:
            return

        with self._lock:
            self._snap.online       = True
            self._snap.last_updated = time.time()

            # Printer state
            state = print_data.get("gcode_state", "")
            if state:
                self._snap.state = state

            # Temperatures
            bt = print_data.get("bed_temper")
            nt = print_data.get("nozzle_temper")
            if bt is not None: self._snap.bed_temp    = float(bt)
            if nt is not None: self._snap.nozzle_temp = float(nt)

            # AMS filaments
            slots = []
            ams_data = print_data.get("ams", {})
            ams_list = ams_data.get("ams", []) if isinstance(ams_data, dict) else []
            for ams_unit in ams_list:
                unit_id = int(ams_unit.get("id", 0)) + 1
                for tray in ams_unit.get("tray", []):
                    tray_id  = tray.get("id", "?")
                    material = tray.get("tray_type", "") or tray.get("tray_id_name", "")
                    color    = tray.get("tray_color", "FFFFFF00")[:6]
                    brand    = tray.get("cols", [{}])[0].get("name", "") \
                               if tray.get("cols") else ""
                    if not material:
                        continue  # empty slot
                    label = f"AMS {unit_id}-{chr(65 + int(str(tray_id))%4)}"
                    slots.append(FilamentSlot(
                        label=label, material=material,
                        color_hex=color, brand=brand,
                    ))

            # External spool (vt_tray)
            vt = print_data.get("vt_tray", {})
            if vt and vt.get("tray_type"):
                slots.append(FilamentSlot(
                    label    = "External",
                    material = vt.get("tray_type", ""),
                    color_hex= vt.get("tray_color", "FFFFFF")[:6],
                    brand    = "",
                ))

            if slots:
                self._snap.filaments = slots


# ─── Module-level singleton, lazily started ───────────────────────────────────

_instance: Optional[BambuStatus] = None


def get_status() -> Optional[BambuStatus]:
    """Return a connected BambuStatus if config has valid credentials."""
    global _instance
    if _instance is not None:
        return _instance
    try:
        import config as cfg
        ip   = getattr(cfg, "BAMBU_IP", "")
        ser  = getattr(cfg, "BAMBU_SERIAL", "")
        code = getattr(cfg, "BAMBU_ACCESS_CODE", "")
        if not ip or ip == "192.168.1.100" or "XXX" in ser:
            return None  # not configured
        _instance = BambuStatus(ip, ser, code)
        _instance.connect()
        return _instance
    except Exception as exc:
        print(f"[bambu_status] init failed: {exc}")
        return None
