"""
Shape grammar engine for simple 3D objects.

Generates .scad source programmatically for boxes, brackets, hooks, etc.
Falls back to a minimal box if the shape is unrecognized.
"""

import os
import subprocess
import time

import config
from utils.logger import get_logger

log = get_logger(__name__)


def generate(intent) -> str:
    """
    Generate an STL for a shape-based object.

    Returns:
        Absolute path to the generated STL file.
    """
    obj_class = intent.object_class
    w = intent.width_mm  or _defaults(obj_class)[0]
    h = intent.height_mm or _defaults(obj_class)[1]
    d = intent.depth_mm  or _defaults(obj_class)[2]

    generator = _GENERATORS.get(obj_class, _gen_box)
    scad_source = generator(w, h, d)

    return _run_openscad(scad_source, obj_class)


# ─── Shape generators ─────────────────────────────────────────────────────────

def _gen_box(w: float, h: float, d: float) -> str:
    chamfer = min(w, h, d) * 0.05
    return f"""
// DAVIS — Box
use <{config.SCAD_TEMPLATES}/base_shapes.scad>
chamfer_box({w}, {h}, {d}, {chamfer:.2f});
"""

def _gen_bracket(w: float, h: float, d: float) -> str:
    thickness = max(2.0, min(w, h) * 0.15)
    return f"""
// DAVIS — L-Bracket
use <{config.SCAD_TEMPLATES}/base_shapes.scad>
l_bracket({w}, {h}, {w*0.4:.1f}, {h*0.4:.1f}, {thickness:.1f}, {d});
"""

def _gen_hook(w: float, h: float, d: float) -> str:
    r = min(w, h) * 0.3
    wire_d = max(3.0, min(w, h) * 0.12)
    return f"""
// DAVIS — S-Hook
use <{config.SCAD_TEMPLATES}/base_shapes.scad>
s_hook(r={r:.1f}, wire_d={wire_d:.1f});
"""

def _gen_knob(w: float, h: float, d: float) -> str:
    r = w / 2
    return f"""
// DAVIS — Knob
$fn = 64;
difference() {{
    cylinder(r={r:.1f}, h={h:.1f});
    // Grip ridges
    for (i = [0:11]) {{
        rotate([0,0,i*30])
        translate([{r:.1f}, 0, 0])
        cylinder(r=1.5, h={h:.1f}+0.2, $fn=16);
    }}
    // Shaft hole
    translate([0,0,-0.1])
    cylinder(r=2.5, h={h:.1f}+0.2, $fn=32);
}}
"""

def _gen_cylinder(w: float, h: float, d: float) -> str:
    return f"""
// DAVIS — Cylinder
$fn = 64;
cylinder(r={w/2:.1f}, h={h:.1f});
"""

def _gen_ring(w: float, h: float, d: float) -> str:
    outer_r = w / 2
    wall = max(2.0, w * 0.15)
    inner_r = outer_r - wall
    return f"""
// DAVIS — Ring
$fn = 64;
difference() {{
    cylinder(r={outer_r:.1f}, h={h:.1f});
    translate([0,0,-0.1]) cylinder(r={inner_r:.1f}, h={h:.1f}+0.2);
}}
"""

def _gen_stand(w: float, h: float, d: float) -> str:
    base_h = max(3.0, h * 0.15)
    post_w = max(4.0, w * 0.12)
    return f"""
// DAVIS — Stand
// Base
cube([{w:.1f}, {d:.1f}, {base_h:.1f}]);
// Post
translate([({w:.1f}-{post_w:.1f})/2, ({d:.1f}-{post_w:.1f})/2, {base_h:.1f}])
    cube([{post_w:.1f}, {post_w:.1f}, {h-base_h:.1f}]);
"""

def _gen_holder(w: float, h: float, d: float) -> str:
    wall = max(2.0, w * 0.1)
    return f"""
// DAVIS — Holder (open-top box)
difference() {{
    cube([{w:.1f}, {d:.1f}, {h:.1f}]);
    translate([{wall:.1f}, {wall:.1f}, {wall:.1f}])
        cube([{w-2*wall:.1f}, {d-2*wall:.1f}, {h:.1f}]);
}}
"""


_GENERATORS = {
    "box":         _gen_box,
    "cube":        _gen_box,
    "replacement": _gen_box,
    "bracket":     _gen_bracket,
    "hook":        _gen_hook,
    "knob":        _gen_knob,
    "cylinder":    _gen_cylinder,
    "ring":        _gen_ring,
    "stand":       _gen_stand,
    "holder":      _gen_holder,
}


def _defaults(obj_class: str) -> tuple:
    """(width, height, depth) defaults in mm."""
    return {
        "box":         (40, 30, 20),
        "cube":        (30, 30, 30),
        "bracket":     (40, 40, 30),
        "hook":        (25, 40, 8),
        "knob":        (30, 20, 30),
        "cylinder":    (25, 40, 25),
        "ring":        (30, 8,  30),
        "stand":       (60, 80, 20),
        "holder":      (50, 50, 60),
        "replacement": (40, 30, 20),
    }.get(obj_class, (40, 30, 20))


# ─── OpenSCAD runner ──────────────────────────────────────────────────────────

def _run_openscad(scad_source: str, obj_class: str) -> str:
    os.makedirs(config.STL_OUTPUT_DIR, exist_ok=True)
    timestamp = int(time.time())
    scad_path = os.path.join(config.STL_OUTPUT_DIR, f"{obj_class}_{timestamp}.scad")
    stl_path  = os.path.join(config.STL_OUTPUT_DIR, f"{obj_class}_{timestamp}.stl")

    with open(scad_path, "w") as f:
        f.write(scad_source)

    cmd = [config.OPENSCAD_BIN, "-o", stl_path, scad_path]
    log.info("Running OpenSCAD (shape): %s", " ".join(cmd))

    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=config.OPENSCAD_TIMEOUT_S,
        )
    except subprocess.TimeoutExpired:
        raise RuntimeError(f"OpenSCAD timed out after {config.OPENSCAD_TIMEOUT_S}s")
    except FileNotFoundError:
        raise RuntimeError(f"OpenSCAD binary not found: {config.OPENSCAD_BIN!r}")

    if result.returncode != 0:
        raise RuntimeError(f"OpenSCAD error:\n{result.stderr}")

    if not os.path.isfile(stl_path) or os.path.getsize(stl_path) == 0:
        raise RuntimeError(f"OpenSCAD produced no output at {stl_path}")

    log.info("STL generated: %s (%.1f KB)", stl_path, os.path.getsize(stl_path) / 1024)
    return stl_path
