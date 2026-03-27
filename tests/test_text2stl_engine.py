"""Tests for the Text2STL engine."""

import os
import pytest
import numpy as np


# ── Skip if required packages aren't installed ────────────────────────────────

def _deps_available() -> bool:
    try:
        import fonttools, shapely, trimesh
        return True
    except ImportError:
        return False


pytestmark = pytest.mark.skipif(
    not _deps_available(),
    reason="fonttools/shapely/trimesh not installed"
)


from generation.text2stl_engine import (
    Text2STLParams,
    generate_text_stl,
    generate,
    _flatten_cubic,
    _flatten_quadratic,
    _signed_area,
    _find_default_font,
)


# ── Unit tests: math helpers ──────────────────────────────────────────────────

def test_flatten_cubic_returns_points():
    p0 = np.array([0.0, 0.0])
    p1 = np.array([1.0, 2.0])
    p2 = np.array([3.0, 2.0])
    p3 = np.array([4.0, 0.0])
    pts = _flatten_cubic(p0, p1, p2, p3)
    assert len(pts) >= 1
    # Last point must equal p3
    assert np.allclose(pts[-1], p3)


def test_flatten_quadratic_returns_points():
    p0 = np.array([0.0, 0.0])
    p1 = np.array([2.0, 4.0])
    p2 = np.array([4.0, 0.0])
    pts = _flatten_quadratic(p0, p1, p2)
    assert len(pts) >= 1
    assert np.allclose(pts[-1], p2)


def test_signed_area_ccw():
    # CCW square → positive area
    pts = [
        np.array([0.0, 0.0]),
        np.array([1.0, 0.0]),
        np.array([1.0, 1.0]),
        np.array([0.0, 1.0]),
    ]
    assert _signed_area(pts) > 0


def test_signed_area_cw():
    # CW square → negative area
    pts = [
        np.array([0.0, 0.0]),
        np.array([0.0, 1.0]),
        np.array([1.0, 1.0]),
        np.array([1.0, 0.0]),
    ]
    assert _signed_area(pts) < 0


def test_find_default_font():
    path = _find_default_font()
    assert os.path.isfile(path)
    assert path.endswith((".ttf", ".otf", ".ttc"))


# ── Integration tests: STL generation ─────────────────────────────────────────

def test_generate_simple_label(tmp_path):
    out = str(tmp_path / "label.stl")
    result = generate("HELLO", out, font_size_mm=8.0, extrude_depth_mm=2.0, base=True)
    assert result == out
    assert os.path.isfile(out)
    assert os.path.getsize(out) > 1000   # at least 1 KB


def test_generate_multiline(tmp_path):
    out = str(tmp_path / "multi.stl")
    result = generate("LINE 1\nLINE 2", out, font_size_mm=6.0)
    assert os.path.isfile(result)
    assert os.path.getsize(result) > 0


def test_generate_no_base(tmp_path):
    out = str(tmp_path / "nobase.stl")
    result = generate("TEXT", out, base=False, extrude_depth_mm=5.0)
    assert os.path.isfile(result)


def test_generate_dimensions_respected(tmp_path):
    """STL bounding box should roughly match requested dimensions."""
    import trimesh as tm
    out = str(tmp_path / "sized.stl")
    generate("DAVIS", out, font_size_mm=10.0, extrude_depth_mm=3.0,
             base=True, base_thickness_mm=2.0, base_padding_mm=3.0)

    mesh = tm.load(out)
    extents = mesh.bounding_box.extents
    # Z = extrude_depth + base_thickness = 5mm
    assert 4.0 < extents[2] < 7.0, f"Unexpected Z extent: {extents[2]}"


def test_generate_text_gen_wrapper(tmp_path):
    """text_gen.generate() should return a valid STL via the engine."""
    import config
    config.STL_OUTPUT_DIR = str(tmp_path)

    from generation import text_gen
    from voice.intent_parser import Intent

    intent = Intent(
        object_class="label",
        text_content="WORKSHOP",
        width_mm=60, height_mm=20, depth_mm=3,
        font_size=None, raw="make a label that says workshop",
    )
    path = text_gen.generate(intent)
    assert os.path.isfile(path)
    assert os.path.getsize(path) > 0


def test_empty_text_raises(tmp_path):
    out = str(tmp_path / "empty.stl")
    with pytest.raises(RuntimeError):
        generate("   ", out)


def test_special_characters(tmp_path):
    out = str(tmp_path / "special.stl")
    # Digits and punctuation should render without crashing
    result = generate("BIN #3 / 2024", out)
    assert os.path.isfile(result)
