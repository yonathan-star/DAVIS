"""Tests for Bambu client modules (mocked — no real printer needed)."""

import ssl
from unittest.mock import MagicMock, patch, call
import pytest

from printer import ftps_transfer, mqtt_client


# ─── FTPS transfer ────────────────────────────────────────────────────────────

def test_upload_stl_success(tmp_path):
    stl = tmp_path / "test.stl"
    stl.write_bytes(b"solid test\nendsolid test\n")

    mock_ftp = MagicMock()
    with patch("printer.ftps_transfer.ImplicitFTP_TLS", return_value=mock_ftp):
        result = ftps_transfer.upload_stl(str(stl))

    assert result == "test.stl"
    mock_ftp.login.assert_called_once()
    mock_ftp.storbinary.assert_called_once()


def test_upload_stl_retries_on_failure(tmp_path):
    stl = tmp_path / "test.stl"
    stl.write_bytes(b"solid test\nendsolid test\n")

    import config
    original = config.MAX_FTPS_RETRIES
    config.MAX_FTPS_RETRIES = 2

    mock_ftp = MagicMock()
    mock_ftp.connect.side_effect = ConnectionRefusedError("refused")
    with patch("printer.ftps_transfer.ImplicitFTP_TLS", return_value=mock_ftp):
        with pytest.raises(RuntimeError, match="FTPS transfer failed"):
            ftps_transfer.upload_stl(str(stl))

    config.MAX_FTPS_RETRIES = original


# ─── MQTT client ──────────────────────────────────────────────────────────────

def test_build_payload_contains_filename():
    payload = mqtt_client._build_payload("my_label.stl")
    assert "my_label.stl" in payload["print"]["subtask_name"]
    assert "my_label.stl" in payload["print"]["url"]


def test_send_print_job_success():
    with patch("printer.mqtt_client._publish_once") as mock_pub:
        mqtt_client.send_print_job("test.stl")
    mock_pub.assert_called_once()
    topic, payload = mock_pub.call_args[0]
    import config
    assert config.BAMBU_SERIAL in topic
    assert payload["print"]["subtask_name"] == "test.stl"


def test_send_print_job_retries(monkeypatch):
    import config
    original = config.MAX_MQTT_RETRIES
    config.MAX_MQTT_RETRIES = 2

    call_count = [0]
    def fail(*a, **kw):
        call_count[0] += 1
        raise ConnectionError("refused")

    monkeypatch.setattr(mqtt_client, "_publish_once", fail)
    with pytest.raises(RuntimeError):
        mqtt_client.send_print_job("test.stl")

    assert call_count[0] == 2
    config.MAX_MQTT_RETRIES = original
