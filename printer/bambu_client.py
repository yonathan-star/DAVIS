"""
Bambu Labs print orchestrator.

Coordinates FTPS upload → MQTT dispatch in response to GESTURE_CONFIRM.
"""

import threading

from core.event_bus import bus, GESTURE_CONFIRM, GESTURE_CANCEL, PRINT_STARTED, PRINT_COMPLETE, FAULT
from core.state_machine import sm, State
from printer import ftps_transfer, mqtt_client
from utils.logger import get_logger

log = get_logger(__name__)


class BambuClient:
    def __init__(self):
        bus.subscribe(GESTURE_CONFIRM, self._on_confirm)
        bus.subscribe(GESTURE_CANCEL,  self._on_cancel)

    def _on_confirm(self, _event) -> None:
        if sm.state not in (State.PREVIEWING, State.CONFIRMING):
            return

        stl_path = sm.context.get("stl_path")
        if not stl_path:
            sm.fault("No STL ready to print")
            return

        sm.transition(State.CONFIRMING, reason="confirm gesture")
        # Small debounce — confirm transitions to PRINTING only after
        # the state machine registers CONFIRMING, which requires the
        # gesture interpreter to hold for CONFIRM_HOLD_S. By the time
        # this handler fires the hold is already complete.
        sm.transition(State.PRINTING, reason="print confirmed")
        bus.publish(PRINT_STARTED, {"stl_path": stl_path})

        thread = threading.Thread(
            target=self._send,
            args=(stl_path,),
            daemon=True,
            name="bambu-send",
        )
        thread.start()

    def _on_cancel(self, _event) -> None:
        if sm.state in (State.PREVIEWING, State.CONFIRMING):
            sm.reset_context()
            sm.transition(State.IDLE, reason="cancel gesture")
            log.info("Print cancelled by user gesture")

    def _send(self, stl_path: str) -> None:
        try:
            remote_filename = ftps_transfer.upload_stl(stl_path)
            mqtt_client.send_print_job(remote_filename)
            log.info("Print job dispatched: %s", remote_filename)
            bus.publish(PRINT_COMPLETE, {"remote_filename": remote_filename})
            sm.reset_context()
            sm.transition(State.IDLE, reason="print dispatched")
        except Exception as exc:
            log.exception("Print dispatch failed: %s", exc)
            sm.fault(str(exc))
