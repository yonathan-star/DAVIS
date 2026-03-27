"""
DAVIS Model Generator

Generates 3D models from natural language descriptions using trimesh
primitives — no OpenSCAD required, runs on Windows and Pi alike.

Supported shapes:
    box / cube / container / bin / storage
    cylinder / tube / pipe / rod / dowel
    cone / funnel
    sphere / ball
    bracket / L-bracket / angle
    hook / J-hook / S-hook
    ring / washer / gasket
    stand / base / pedestal
    wedge / ramp / doorstop
    hex / hexagon / nut-blank
    cross / plus
    pyramid

Each shape accepts width / height / depth in mm extracted from the description.
"""

from __future__ import annotations

import math
import re
from dataclasses import dataclass, field
from typing import Optional

import numpy as np
import trimesh
import trimesh.creation
from shapely.geometry import Polygon
from shapely.ops import unary_union

from utils.logger import get_logger

log = get_logger(__name__)


# ─── Intent dataclass ────────────────────────────────────────────────────────

@dataclass
class ModelIntent:
    shape: str
    width_mm: float  = 40.0
    height_mm: float = 30.0
    depth_mm: float  = 20.0
    wall_mm: float   = 2.5
    raw: str         = ""


# ─── Description parser ───────────────────────────────────────────────────────

UNIT_TO_MM = {
    "mm": 1, "millimeter": 1, "millimeters": 1,
    "cm": 10, "centimeter": 10, "centimeters": 10,
    "m":  1000, "meter": 1000,
    "in": 25.4, "inch": 25.4, "inches": 25.4,
    "\"": 25.4,
}

SHAPE_ALIASES = {
    # box family
    "box": "box", "cube": "box", "block": "box", "container": "box",
    "bin": "box", "storage": "box", "tray": "box", "drawer": "box",
    "crate": "box", "enclosure": "box",
    # cylinder family
    "cylinder": "cylinder", "tube": "cylinder", "pipe": "cylinder",
    "rod": "cylinder", "dowel": "cylinder", "peg": "cylinder",
    "pillar": "cylinder", "column": "cylinder", "barrel": "cylinder",
    # cone
    "cone": "cone", "funnel": "cone", "spike": "cone", "nozzle": "cone",
    # sphere
    "sphere": "sphere", "ball": "sphere", "globe": "sphere",
    # bracket
    "bracket": "bracket", "l-bracket": "bracket", "angle": "bracket",
    "corner": "bracket", "mount": "bracket", "shelf bracket": "bracket",
    # hook
    "hook": "hook", "j-hook": "hook", "s-hook": "hook",
    "peg hook": "hook", "wall hook": "hook",
    # ring
    "ring": "ring", "washer": "ring", "gasket": "ring",
    "o-ring": "ring", "spacer": "ring", "annulus": "ring",
    # stand
    "stand": "stand", "base": "stand", "pedestal": "stand",
    "riser": "stand", "platform": "stand", "foot": "stand",
    # wedge
    "wedge": "wedge", "ramp": "wedge", "doorstop": "wedge",
    "shim": "wedge", "chock": "wedge",
    # hex
    "hex": "hex", "hexagon": "hex", "nut blank": "hex",
    "bolt blank": "hex",
    # cross
    "cross": "cross", "plus": "cross",
    # pyramid
    "pyramid": "pyramid", "obelisk": "pyramid",
}

_UNITS_PAT = r"mm|cm|m\b|in\b|inch|inches|millimeters?|centimeters?"
_NUM_PAT   = r"(\d+(?:\.\d+)?)"
_UNIT_CAP  = r"(mm|cm|m\b|in\b|inch(?:es)?|millimeters?|centimeters?)"

# Each tuple: (axis, list of qualifier words)
_AXIS_KEYWORDS = [
    ("w", ["wide", "width", "diameter", "diam", "across", "radius"]),
    ("h", ["tall", "high", "height", "long", "length", "size"]),
    ("d", ["deep", "depth", "thick", "thickness"]),
]


def parse_description(text: str) -> Optional[ModelIntent]:
    """
    Parse a free-form description into a ModelIntent.
    Returns None if no recognisable shape is found.
    """
    t = text.lower().strip()

    # Find shape
    shape = None
    for alias, canonical in sorted(SHAPE_ALIASES.items(), key=lambda x: -len(x[0])):
        if alias in t:
            shape = canonical
            break
    if shape is None:
        return None

    defaults = _shape_defaults(shape)
    wall_val = _extract_wall(t)

    # Find all (value_mm, char_position) pairs in the text
    all_vals: list[tuple[float, int]] = []
    for m in re.finditer(_NUM_PAT + r"\s*" + _UNIT_CAP, t, re.IGNORECASE):
        mm = float(m.group(1)) * UNIT_TO_MM.get(m.group(2).lower().rstrip("s").replace("illimeter","mm").replace("entimeter","cm"), 1)
        # simpler: just look up directly
        raw_unit = m.group(2).lower()
        factor = next((v for k, v in UNIT_TO_MM.items() if raw_unit.startswith(k[:2])), 1)
        all_vals.append((float(m.group(1)) * factor, m.start()))

    # Try to assign each value to an axis using surrounding keywords
    assigned = {"w": None, "h": None, "d": None}
    used_positions: set[int] = set()

    for axis, keywords in _AXIS_KEYWORDS:
        for kw in keywords:
            for val_mm, pos in all_vals:
                if pos in used_positions:
                    continue
                # Check if keyword appears within 20 chars before or after the number
                window = t[max(0, pos-20): pos+20]
                if kw in window:
                    assigned[axis] = val_mm
                    used_positions.add(pos)
                    break
            if assigned[axis] is not None:
                break

    # Fill remaining axes from leftover positional values
    leftover = [v for v, pos in all_vals if pos not in used_positions
                and (wall_val is None or abs(v - wall_val) > 0.1)]
    for axis in ("w", "h", "d"):
        if assigned[axis] is None and leftover:
            assigned[axis] = leftover.pop(0)

    intent = ModelIntent(
        shape    = shape,
        width_mm = assigned["w"] or defaults[0],
        height_mm= assigned["h"] or defaults[1],
        depth_mm = assigned["d"] or defaults[2],
        wall_mm  = wall_val      or defaults[3],
        raw      = text,
    )
    log.info("Parsed: shape=%s  %.0fx%.0fx%.0f mm", shape, intent.width_mm, intent.height_mm, intent.depth_mm)
    return intent


def _shape_defaults(shape: str) -> tuple:
    """(width, height, depth, wall) defaults in mm."""
    return {
        "box":      (50, 30, 40, 2.5),
        "cylinder": (30, 50, 30, 2.5),
        "cone":     (30, 50, 30, 2.0),
        "sphere":   (30, 30, 30, 2.0),
        "bracket":  (40, 40, 30, 3.0),
        "hook":     (20, 60, 8,  3.0),
        "ring":     (30, 8,  30, 3.0),
        "stand":    (60, 20, 40, 3.0),
        "wedge":    (60, 20, 40, 2.0),
        "hex":      (30, 15, 30, 2.0),
        "cross":    (60, 60, 10, 2.0),
        "pyramid":  (40, 50, 40, 2.0),
    }.get(shape, (40, 30, 40, 2.5))


def _extract_wall(text: str) -> Optional[float]:
    m = re.search(r"wall\s+(\d+(?:\.\d+)?)\s*(mm|cm)?", text, re.IGNORECASE)
    if m:
        val = float(m.group(1))
        unit = (m.group(2) or "mm").lower()
        return val * UNIT_TO_MM.get(unit, 1)
    return None


# ─── Shape generators ─────────────────────────────────────────────────────────

def generate(intent: ModelIntent) -> trimesh.Trimesh:
    """Generate a trimesh solid from a ModelIntent."""
    fn = {
        "box":      _box,
        "cylinder": _cylinder,
        "cone":     _cone,
        "sphere":   _sphere,
        "bracket":  _bracket,
        "hook":     _hook,
        "ring":     _ring,
        "stand":    _stand,
        "wedge":    _wedge,
        "hex":      _hex,
        "cross":    _cross,
        "pyramid":  _pyramid,
    }.get(intent.shape, _box)
    return fn(intent)


def _box(i: ModelIntent) -> trimesh.Trimesh:
    w, h, d, t = i.width_mm, i.height_mm, i.depth_mm, i.wall_mm
    # Hollow box (open-top container) if large enough, else solid block
    if w > t * 4 and d > t * 4 and h > t * 3:
        outer = trimesh.creation.box([w, d, h])
        inner = trimesh.creation.box([w - t*2, d - t*2, h - t])
        inner.apply_translation([0, 0, t / 2])
        return _difference(outer, inner)
    return trimesh.creation.box([w, d, h])


def _cylinder(i: ModelIntent) -> trimesh.Trimesh:
    r, h, t = i.width_mm / 2, i.height_mm, i.wall_mm
    outer = trimesh.creation.cylinder(radius=r, height=h, sections=64)
    if r > t * 2:
        inner = trimesh.creation.cylinder(radius=max(1, r - t), height=h + 0.2, sections=64)
        return _difference(outer, inner)
    return outer


def _cone(i: ModelIntent) -> trimesh.Trimesh:
    return trimesh.creation.cone(radius=i.width_mm / 2, height=i.height_mm, sections=64)


def _sphere(i: ModelIntent) -> trimesh.Trimesh:
    return trimesh.creation.icosphere(subdivisions=4, radius=i.width_mm / 2)


def _bracket(i: ModelIntent) -> trimesh.Trimesh:
    w, h, d, t = i.width_mm, i.height_mm, i.depth_mm, i.wall_mm
    # L-shape: vertical plate + horizontal plate
    vert  = trimesh.creation.box([t, d, h])
    horiz = trimesh.creation.box([w, d, t])
    vert.apply_translation( [-(w - t) / 2, 0, 0])
    horiz.apply_translation([t / 2, 0, -(h - t) / 2])
    mesh = trimesh.util.concatenate([vert, horiz])
    # Gusset triangle for strength
    gusset_pts = np.array([[0,0], [0, h*0.4], [w*0.4, 0]])
    gusset = _extrude_poly(gusset_pts, d)
    gusset.apply_translation([-(w-t)/2 + t, -d/2, -(h-t)/2])
    return trimesh.util.concatenate([mesh, gusset])


def _hook(i: ModelIntent) -> trimesh.Trimesh:
    w, h, t = i.width_mm, i.height_mm, i.wall_mm
    r  = w / 2
    sections = 48
    parts = []

    # Vertical shaft
    shaft = trimesh.creation.cylinder(radius=t / 2, height=h * 0.5, sections=sections)
    shaft.apply_translation([0, 0, h * 0.25])
    parts.append(shaft)

    # Curved hook tip (torus segment)
    for angle_deg in range(0, 200, 5):
        a0 = math.radians(angle_deg)
        a1 = math.radians(angle_deg + 5)
        cx0 = r * math.cos(a0)
        cy0 = r * math.sin(a0)
        cx1 = r * math.cos(a1)
        cy1 = r * math.sin(a1)
        seg = trimesh.creation.cylinder(
            radius=t / 2,
            height=math.hypot(cx1 - cx0, cy1 - cy0),
            sections=12,
        )
        mid_x = (cx0 + cx1) / 2
        mid_y = (cy0 + cy1) / 2
        seg.apply_translation([mid_x, mid_y, 0])
        angle_z = math.atan2(cy1 - cy0, cx1 - cx0)
        seg.apply_transform(trimesh.transformations.rotation_matrix(
            math.pi / 2, [0, 0, 1]
        ))
        seg.apply_transform(trimesh.transformations.rotation_matrix(
            -angle_z, [0, 1, 0]
        ))
        parts.append(seg)

    # Wall mount plate
    plate = trimesh.creation.box([t * 3, t * 2, h * 0.25])
    plate.apply_translation([0, -t, h * 0.5 + h * 0.125])
    parts.append(plate)

    return trimesh.util.concatenate(parts)


def _ring(i: ModelIntent) -> trimesh.Trimesh:
    outer_r = i.width_mm / 2
    inner_r = max(1, outer_r - i.wall_mm)
    outer   = trimesh.creation.cylinder(radius=outer_r, height=i.height_mm, sections=64)
    inner   = trimesh.creation.cylinder(radius=inner_r, height=i.height_mm + 0.2, sections=64)
    return _difference(outer, inner)


def _stand(i: ModelIntent) -> trimesh.Trimesh:
    w, h, d, t = i.width_mm, i.height_mm, i.depth_mm, i.wall_mm
    base = trimesh.creation.box([w, d, t * 2])
    base.apply_translation([0, 0, -h / 2 + t])
    post_r = min(w, d) * 0.12
    post   = trimesh.creation.cylinder(radius=post_r, height=h - t * 2, sections=32)
    return trimesh.util.concatenate([base, post])


def _wedge(i: ModelIntent) -> trimesh.Trimesh:
    w, h, d = i.width_mm, i.height_mm, i.depth_mm
    verts = np.array([
        [0, 0, 0], [w, 0, 0], [w, d, 0], [0, d, 0],
        [0, 0, h], [0, d, h],
    ])
    faces = np.array([
        [0,1,2],[0,2,3],   # bottom
        [0,4,5],[0,5,3],   # left (ramp face)
        [0,1,4],           # front triangle
        [3,5,2],           # back triangle
        [1,2,5],[1,5,4],   # hypotenuse face
    ])
    return trimesh.Trimesh(vertices=verts, faces=faces, process=True)


def _hex(i: ModelIntent) -> trimesh.Trimesh:
    r, h = i.width_mm / 2, i.height_mm
    angles = [math.radians(a) for a in range(0, 360, 60)]
    pts = np.array([[r * math.cos(a), r * math.sin(a)] for a in angles])
    return _extrude_poly(pts, h)


def _cross(i: ModelIntent) -> trimesh.Trimesh:
    w, h, d, t = i.width_mm, i.height_mm, i.depth_mm, i.wall_mm
    arm_w = min(w, h) * 0.3
    horiz = trimesh.creation.box([w, arm_w, d])
    vert  = trimesh.creation.box([arm_w, h, d])
    return trimesh.util.concatenate([horiz, vert])


def _pyramid(i: ModelIntent) -> trimesh.Trimesh:
    w, h, d = i.width_mm, i.height_mm, i.depth_mm
    verts = np.array([
        [-w/2, -d/2, 0],
        [ w/2, -d/2, 0],
        [ w/2,  d/2, 0],
        [-w/2,  d/2, 0],
        [0,    0,    h],
    ])
    faces = np.array([
        [0,1,2],[0,2,3],   # base
        [0,1,4],[1,2,4],[2,3,4],[3,0,4],  # sides
    ])
    return trimesh.Trimesh(vertices=verts, faces=faces, process=True)


# ─── Helpers ──────────────────────────────────────────────────────────────────

def _extrude_poly(pts_2d: np.ndarray, height: float) -> trimesh.Trimesh:
    from shapely.geometry import Polygon as SPoly
    poly = SPoly(pts_2d)
    return trimesh.creation.extrude_polygon(poly, height)


def _difference(a: trimesh.Trimesh, b: trimesh.Trimesh) -> trimesh.Trimesh:
    """Boolean difference a-b, falls back to just returning a on failure."""
    try:
        result = trimesh.boolean.difference([a, b], engine="manifold")
        if result is not None and len(result.faces) > 0:
            return result
    except Exception:
        pass
    try:
        result = trimesh.boolean.difference([a, b], engine="blender")
        if result is not None and len(result.faces) > 0:
            return result
    except Exception:
        pass
    log.warning("Boolean difference failed — returning outer shell only")
    return a
