"""Tests for text_gen STL generation (requires openscad on PATH)."""

import os
import pytest

from voice.intent_parser import Intent
from generation import text_gen


def _make_intent(cls, text, w=None, h=None, d=None):
    return Intent(
        object_class=cls,
        text_content=text,
        width_mm=w, height_mm=h, depth_mm=d,
        font_size=None, raw="",
    )


@pytest.fixture(autouse=True)
def require_openscad():
    import shutil
    if shutil.which("openscad") is None:
        pytest.skip("openscad not installed")


def test_label_generates_stl():
    intent = _make_intent("label", "TEST")
    path = text_gen.generate(intent)
    assert os.path.isfile(path)
    assert os.path.getsize(path) > 0
    os.remove(path)


def test_nameplate_generates_stl():
    intent = _make_intent("nameplate", "DAVIS", w=80, h=25)
    path = text_gen.generate(intent)
    assert os.path.isfile(path)
    os.remove(path)


def test_tag_generates_stl():
    intent = _make_intent("tag", "FRAGILE")
    path = text_gen.generate(intent)
    assert os.path.isfile(path)
    os.remove(path)


def test_missing_template_raises():
    intent = _make_intent("nonexistent_template_xyz", "HI")
    # nonexistent_template_xyz maps to label.scad (default), so it should work
    # Actually test with a deliberately broken config
    import config as cfg
    original = cfg.SCAD_TEMPLATES
    cfg.SCAD_TEMPLATES = "/nonexistent/path"
    with pytest.raises(RuntimeError):
        text_gen.generate(intent)
    cfg.SCAD_TEMPLATES = original
