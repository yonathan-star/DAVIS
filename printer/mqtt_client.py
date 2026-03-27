"""
MQTT print job dispatcher for Bambu Labs printers.

Connects to the printer's built-in broker on port 8883 (TLS).
Publishes a print command JSON to device/{serial}/request.
"""

import json
import ssl
import threading
import time
from typing import Optional

import paho.mqtt.client as mqtt

import config
from utils.logger import get_logger

log = get_logger(__name__)

BAMBU_USERNAME = "bblp"
PRINT_TOPIC_TMPL = "device/{serial}/request"
REPORT_TOPIC_TMPL = "device/{serial}/report"


def send_print_job(remote_filename: str, bambu_status=None) -> None:
    """
    Dispatch a print job to the Bambu printer via MQTT.

    Args:
        remote_filename: filename (without path) already uploaded via FTPS.
        bambu_status:    optional BambuStatus instance with a live MQTT
                         connection.  If provided (and connected), the
                         existing connection is reused instead of opening
                         a new one (the printer only accepts one MQTT client).

    Raises:
        RuntimeError on failure.
    """
    payload = _build_payload(remote_filename)

    # Prefer the already-connected status client to avoid second-connection rejection
    if bambu_status is not None:
        ok = bambu_status.publish_command(payload)
        if ok:
            log.info("MQTT print job sent via status connection: %s", remote_filename)
            return
        log.warning("Status client not connected — falling back to new connection")

    topic = PRINT_TOPIC_TMPL.format(serial=config.BAMBU_SERIAL)
    for attempt in range(1, config.MAX_MQTT_RETRIES + 1):
        try:
            _publish_once(topic, payload)
            log.info("MQTT print job sent: %s", remote_filename)
            return
        except Exception as exc:
            log.warning("MQTT attempt %d/%d failed: %s", attempt, config.MAX_MQTT_RETRIES, exc)
            if attempt == config.MAX_MQTT_RETRIES:
                raise RuntimeError(
                    f"MQTT dispatch failed after {config.MAX_MQTT_RETRIES} attempts: {exc}"
                ) from exc
            time.sleep(1)


def _publish_once(topic: str, payload: dict) -> None:
    done = threading.Event()
    error: list = []

    def on_connect(client, userdata, flags, rc, properties=None):
        if rc == 0:
            client.publish(topic, json.dumps(payload), qos=1)
        else:
            error.append(f"MQTT connect failed rc={rc}")
            done.set()

    def on_publish(client, userdata, mid, reason_codes=None, properties=None):
        done.set()

    client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
    client.on_connect = on_connect
    client.on_publish = on_publish

    # TLS — Bambu uses a self-signed cert
    tls_ctx = ssl.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
    tls_ctx.check_hostname = False
    tls_ctx.verify_mode = ssl.CERT_NONE
    client.tls_set_context(tls_ctx)

    client.username_pw_set(BAMBU_USERNAME, config.BAMBU_ACCESS_CODE)
    client.connect(config.BAMBU_IP, config.BAMBU_PORT_MQTT, keepalive=10)
    client.loop_start()

    done.wait(timeout=15)
    client.loop_stop()
    client.disconnect()

    if error:
        raise RuntimeError(error[0])
    if not done.is_set():
        raise RuntimeError("MQTT publish timed out")


def _build_payload(remote_filename: str) -> dict:
    """Build the Bambu print command payload."""
    return {
        "print": {
            "sequence_id": "0",
            "command": "project_file",
            "param": f"Metadata/plate_1.gcode",
            "subtask_name": remote_filename,
            "url": f"ftp://bblp:{config.BAMBU_ACCESS_CODE}@{config.BAMBU_IP}/cache/{remote_filename}",
            "bed_type": "auto",
            "timelapse": False,
            "bed_leveling": True,
            "flow_cali": False,
            "vibration_cali": True,
            "layer_inspect": False,
            "use_ams": False,
            "profile_id": "",
        }
    }
