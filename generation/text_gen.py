"""
Text-based STL generator.

Uses the Text2STL engine (pure Python, offline) for text extrusion,
then optionally merges with OpenSCAD structural templates for borders,
mounting holes, and lanyard holes.

Flow:
  1. text2stl_engine generates 3D text mesh
  2. For label/nameplate/tag: also generate structural base via OpenSCAD
  3. If OpenSCAD is unavailable, the Text2STL output (with built-in base)
     is used directly — the result is still fully printable.
"""

import os
import subprocess
import time
from typing import Optional

import config
from generation import text2stl_engine
from utils.logger import get_logger

log = get_logger(__name__)


# Default dimensions per object class
DEFAULTS = {
    "label":     dict(width=60,  height=20,  depth=3,   base_thickness=2.0, padding=2.5),
    "sign":      dict(width=80,  height=25,  depth=3,   base_thickness=2.0, padding=2.5),
    "plate":     dict(width=80,  height=25,  depth=3,   base_thickness=2.0, padding=2.5),
    "badge":     dict(width=50,  height=30,  depth=3,   base_thickness=2.0, padding=3.0),
    "nameplate": dict(width=80,  height=25,  depth=4,   base_thickness=3.0, padding=3.0),
    "tag":       dict(width=40,  height=55,  depth=2.5, base_thickness=2.0, padding=3.0),
}


def generate(intent) -> str:
    """
    Generate an STL for a text-based object.

    Args:
        intent: Intent dataclass from intent_parser.py

    Returns:
        Absolute path to the generated STL file.

    Raises:
        RuntimeError on failure.
    """
    obj_class = intent.object_class
    defaults  = DEFAULTS.get(obj_class, DEFAULTS["label"])

    w   = intent.width_mm  or defaults["width"]
    h   = intent.height_mm or defaults["height"]
    d   = intent.depth_mm  or defaults["depth"]
    base_t  = defaults["base_thickness"]
    padding = defaults["padding"]

    text = intent.text_content or obj_class.upper()

    os.makedirs(config.STL_OUTPUT_DIR, exist_ok=True)
    slug      = text[:20].replace(" ", "_").replace("/", "-")
    timestamp = int(time.time())
    stl_path  = os.path.join(config.STL_OUTPUT_DIR, f"{obj_class}_{slug}_{timestamp}.stl")

    # ── Font size: fit text height within the object's height ─────────────
    font_size_mm = (h - padding * 2) * 0.75

    log.info("Text2STL generating: class=%s text=%r  %.0fx%.0fx%.0fmm",
             obj_class, text, w, h, d)

    stl_path = text2stl_engine.generate(
        text             = text,
        output_path      = stl_path,
        font_size_mm     = font_size_mm,
        extrude_depth_mm = d,
        width_mm         = w,
        height_mm        = h,
        base             = True,
        base_thickness_mm= base_t,
        base_padding_mm  = padding,
        mode             = "emboss",
    )

    # ── For nameplate / tag: add structural features via OpenSCAD overlay ─
    if obj_class in ("nameplate", "tag") and _openscad_available():
        try:
            stl_path = _add_structural_features(stl_path, obj_class, w, h, d + base_t, timestamp)
        except Exception as exc:
            log.warning("Structural overlay failed (using text-only STL): %s", exc)

    log.info("STL ready: %s", stl_path)
    return stl_path


# ─── OpenSCAD structural overlay ──────────────────────────────────────────────

_NAMEPLATE_HOLES = """
// Add mounting holes to an existing base
difference() {{
    import("{stl_in}", convexity=4);
    translate([{hole_x1}, {cy}, -1])
        cylinder(d={hole_d}, h={total_d}+2, $fn=24);
    translate([{hole_x2}, {cy}, -1])
        cylinder(d={hole_d}, h={total_d}+2, $fn=24);
}}
"""

_TAG_HOLE = """
difference() {{
    import("{stl_in}", convexity=4);
    translate([0, {top_y}, -1])
        cylinder(d={hole_d}, h={total_d}+2, $fn=32);
}}
"""


def _add_structural_features(
    stl_in: str,
    obj_class: str,
    w: float, h: float, total_d: float,
    timestamp: int,
) -> str:
    scad_path = stl_in.replace(".stl", "_struct.scad")
    stl_out   = stl_in.replace(".stl", "_struct.stl")
    # Escape backslashes for OpenSCAD on Windows
    stl_in_escaped = stl_in.replace("\\", "/")

    if obj_class == "nameplate":
        hole_margin = 5.0
        scad_src = _NAMEPLATE_HOLES.format(
            stl_in  = stl_in_escaped,
            hole_x1 = -(w / 2) + hole_margin,
            hole_x2 =  (w / 2) - hole_margin,
            cy      = 0,
            hole_d  = 3.5,
            total_d = total_d,
        )
    elif obj_class == "tag":
        scad_src = _TAG_HOLE.format(
            stl_in  = stl_in_escaped,
            top_y   =  h / 2 - 7,
            hole_d  = 5.0,
            total_d = total_d,
        )
    else:
        return stl_in

    with open(scad_path, "w") as f:
        f.write(scad_src)

    result = subprocess.run(
        [config.OPENSCAD_BIN, "-o", stl_out, scad_path],
        capture_output=True, text=True,
        timeout=config.OPENSCAD_TIMEOUT_S,
    )
    if result.returncode != 0 or not os.path.isfile(stl_out):
        raise RuntimeError(f"OpenSCAD overlay failed: {result.stderr}")

    os.remove(scad_path)
    log.info("Structural features added: %s", stl_out)
    return stl_out


def _openscad_available() -> bool:
    try:
        r = subprocess.run(
            [config.OPENSCAD_BIN, "--version"],
            capture_output=True, timeout=5,
        )
        return r.returncode == 0
    except (FileNotFoundError, subprocess.TimeoutExpired):
        return False
