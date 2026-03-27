"""
Projector display manager.

Opens a pygame fullscreen window on the secondary display (HDMI projector).
Renders STL previews and overlays at a fixed framerate.
"""

import os
import threading
import time

import numpy as np

import config
from core.event_bus import bus, STL_READY, STATE_CHANGED, SHUTDOWN
from core.state_machine import sm, State
from preview import renderer, overlay
from utils.logger import get_logger

log = get_logger(__name__)


class Projector:
    def __init__(self):
        self._model = None
        self._lock  = threading.Lock()
        self._running = False
        self._thread: threading.Thread | None = None

        bus.subscribe(STL_READY,     self._on_stl_ready)
        bus.subscribe(STATE_CHANGED, self._on_state_changed)
        bus.subscribe(SHUTDOWN,      self._on_shutdown)

    def start(self) -> None:
        self._running = True
        self._thread = threading.Thread(
            target=self._display_loop,
            daemon=True,
            name="projector",
        )
        self._thread.start()

    def stop(self) -> None:
        self._running = False
        if self._thread:
            self._thread.join(timeout=3)

    def _on_stl_ready(self, event) -> None:
        stl_path = event.payload.get("stl_path")
        try:
            model = renderer.load_stl(stl_path)
            with self._lock:
                self._model = model
            sm.transition(State.PREVIEWING, reason="stl loaded")
            log.info("Projector loaded model from %s", stl_path)
        except Exception as exc:
            log.exception("Failed to load STL: %s", exc)
            sm.fault(str(exc))

    def _on_state_changed(self, event) -> None:
        to_state = event.payload.get("to")
        if to_state == State.IDLE:
            with self._lock:
                self._model = None

    def _on_shutdown(self, _event) -> None:
        self._running = False

    def _display_loop(self) -> None:
        # Set display env before importing pygame so it targets the right screen
        os.environ.setdefault("DISPLAY", f":{config.PROJECTOR_DISPLAY}")

        import pygame
        pygame.init()
        flags = pygame.FULLSCREEN | pygame.NOFRAME
        screen = pygame.display.set_mode(
            (config.PROJECTOR_WIDTH, config.PROJECTOR_HEIGHT), flags
        )
        pygame.display.set_caption("DAVIS")
        clock = pygame.time.Clock()

        log.info("Projector display started (%dx%d)", config.PROJECTOR_WIDTH, config.PROJECTOR_HEIGHT)

        while self._running:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    self._running = False
                elif event.type == pygame.KEYDOWN and event.key == pygame.K_ESCAPE:
                    self._running = False

            ctx = sm.context
            with self._lock:
                model = self._model

            if model is not None:
                frame = renderer.render_frame(
                    model,
                    config.PROJECTOR_WIDTH,
                    config.PROJECTOR_HEIGHT,
                    scale=ctx.get("scale", 1.0),
                    rotation_deg=ctx.get("rotation", 0.0),
                )
            else:
                # Black frame with status
                frame = np.zeros(
                    (config.PROJECTOR_HEIGHT, config.PROJECTOR_WIDTH, 3), dtype=np.uint8
                )

            frame = overlay.draw(frame)

            # Convert numpy BGR → pygame surface (pygame uses RGB)
            surface = pygame.surfarray.make_surface(
                np.transpose(frame[:, :, ::-1], (1, 0, 2))
            )
            screen.blit(surface, (0, 0))
            pygame.display.flip()
            clock.tick(config.PROJECTION_FPS)

        pygame.quit()
        log.info("Projector display stopped")
