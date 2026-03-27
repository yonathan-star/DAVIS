"""
Structured logging for DAVIS.

All modules use get_logger(__name__) to get a module-tagged logger.
Log level is DEBUG by default in development; set LOG_LEVEL env var to change.
"""

import logging
import os
import sys
from typing import Optional


_initialized = False


def _init_logging() -> None:
    global _initialized
    if _initialized:
        return

    level_name = os.environ.get("LOG_LEVEL", "DEBUG").upper()
    level = getattr(logging, level_name, logging.DEBUG)

    handler = logging.StreamHandler(open(sys.stdout.fileno(),
                                         mode="w", encoding="utf-8",
                                         closefd=False, buffering=1))
    handler.setLevel(level)

    formatter = logging.Formatter(
        fmt="%(asctime)s [%(levelname)-5s] %(name)-28s %(message)s",
        datefmt="%H:%M:%S",
    )
    handler.setFormatter(formatter)

    root = logging.getLogger()
    root.setLevel(level)
    root.addHandler(handler)

    # Silence overly verbose third-party loggers
    for noisy in ("mediapipe", "absl", "matplotlib"):
        logging.getLogger(noisy).setLevel(logging.WARNING)

    _initialized = True


def get_logger(name: Optional[str] = None) -> logging.Logger:
    _init_logging()
    return logging.getLogger(name)
