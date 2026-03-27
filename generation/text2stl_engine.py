"""
DAVIS Text2STL Engine

Converts text → 3D printable STL using:
  matplotlib.textpath  →  glyph outlines (handles all TTF/OTF correctly)
  shapely              →  2D polygon operations (holes, unions)
  trimesh              →  3D extrusion + STL export

Supports any font installed on the system, emboss and engrave modes,
multi-line text, and full parametric sizing.
"""

from __future__ import annotations

import os
import time
from dataclasses import dataclass
from typing import Optional

import numpy as np
from matplotlib import font_manager
from matplotlib.font_manager import FontProperties
from matplotlib.path import Path
from matplotlib.textpath import TextPath
from shapely.geometry import MultiPolygon, Polygon
from shapely.ops import unary_union
import trimesh
import trimesh.creation

import config
from utils.logger import get_logger

log = get_logger(__name__)


# ─── Font resolution ──────────────────────────────────────────────────────────

def _find_font(font_path: Optional[str]) -> str:
    """Return a valid font file path, searching common locations."""
    if font_path and os.path.isfile(font_path):
        return font_path

    # Try to find a bold sans-serif via matplotlib's font manager
    for name in ["Liberation Sans", "DejaVu Sans", "Arial", "Helvetica",
                 "FreeSans", "NimbusSans"]:
        try:
            path = font_manager.findfont(
                FontProperties(family=name, weight="bold"),
                fallback_to_default=False,
            )
            if path and os.path.isfile(path):
                log.info("Using font: %s  (%s)", name, os.path.basename(path))
                return path
        except Exception:
            continue

    # Last resort: matplotlib's bundled default font
    path = font_manager.findfont(FontProperties())
    log.info("Using fallback font: %s", os.path.basename(path))
    return path


# ─── Glyph extraction ─────────────────────────────────────────────────────────

def _text_to_polygons(
    text: str,
    font_path: str,
    font_size: float,
) -> list[Polygon]:
    """
    Convert text to a list of shapely Polygons using matplotlib TextPath.

    matplotlib handles:
      - Bezier curve flattening
      - Glyph spacing and kerning
      - Correct winding direction (outer=CCW, holes=CW) regardless of font format
    """
    fp   = FontProperties(fname=font_path)
    # TextPath size is in points; we'll scale to mm afterwards
    path = TextPath((0, 0), text, size=font_size, prop=fp)

    # path.to_polygons() returns a list of Nx2 arrays, one per closed sub-path
    raw_polys = path.to_polygons(closed_only=True)

    if not raw_polys:
        raise RuntimeError(f"No glyph polygons extracted for text: {text!r}")

    # Build shapely Polygon for each sub-path
    sub_polys = []
    for pts in raw_polys:
        if len(pts) < 3:
            continue
        try:
            p = Polygon(pts).buffer(0)   # buffer(0) fixes any self-intersections
            if p.is_valid and not p.is_empty:
                sub_polys.append(p)
        except Exception:
            continue

    if not sub_polys:
        raise RuntimeError(f"All glyph polygons invalid for text: {text!r}")

    # Combine sub-paths using XOR (symmetric difference) so that outer contours
    # and inner contours (holes like in 'O', 'B', 'D') combine correctly.
    # unary_union followed by symmetric_difference with holes works because
    # matplotlib outputs winding-consistent paths.
    result = _combine_subpaths(sub_polys)
    return result


def _combine_subpaths(polys: list[Polygon]) -> list[Polygon]:
    """
    Combine glyph sub-paths into correct filled polygons with holes.

    Strategy: sort by area (largest first = outer contours), then for each
    subsequent polygon check if it's inside an outer contour → it's a hole.
    Overlapping shapes at the same level → union.
    """
    polys_sorted = sorted(polys, key=lambda p: p.area, reverse=True)
    result_polys = []

    for poly in polys_sorted:
        added = False
        for i, existing in enumerate(result_polys):
            if existing.contains(poly):
                # This poly is a hole inside an existing shell
                result_polys[i] = existing.difference(poly)
                added = True
                break
        if not added:
            result_polys.append(poly)

    return result_polys


# ─── Parameters ───────────────────────────────────────────────────────────────

@dataclass
class Text2STLParams:
    text: str
    font_path: Optional[str]    = None
    font_size_mm: float         = 10.0
    extrude_depth_mm: float     = 3.0
    base: bool                  = True
    base_thickness_mm: float    = 2.0
    base_padding_mm: float      = 3.0
    mode: str                   = "emboss"   # "emboss" or "engrave"
    line_spacing: float         = 1.3


# ─── Main generation function ─────────────────────────────────────────────────

def generate_text_stl(params: Text2STLParams, output_path: str) -> str:
    """
    Generate a 3D STL from text.

    Returns output_path on success. Raises RuntimeError on failure.
    """
    font_path = _find_font(params.font_path)

    log.info("Text2STL: %r  font=%s  size=%.1fmm  depth=%.1fmm  mode=%s",
             params.text, os.path.basename(font_path),
             params.font_size_mm, params.extrude_depth_mm, params.mode)

    # Handle multi-line text by generating each line separately
    lines = params.text.split("\n")
    all_polys = []

    # matplotlib TextPath size is in "points" internally but we use it as a
    # unitless scale — we'll scale the resulting geometry to mm afterwards.
    # We calibrate so that the cap height equals font_size_mm.
    REFERENCE_SIZE = 100.0   # render at this size, then scale

    for line_idx, line in enumerate(lines):
        if not line.strip():
            continue

        polys = _text_to_polygons(line.strip(), font_path, REFERENCE_SIZE)

        # Measure actual cap height of this render
        if polys:
            all_y = []
            for p in polys:
                coords = np.array(p.exterior.coords)
                all_y.extend(coords[:, 1].tolist())
            cap_h  = max(all_y) - min(all_y) if all_y else REFERENCE_SIZE
            scale  = params.font_size_mm / cap_h if cap_h > 0 else 1.0

            # Y offset for this line
            y_offset = -line_idx * params.font_size_mm * params.line_spacing

            from shapely.affinity import scale as shapely_scale, translate
            for p in polys:
                p_scaled = shapely_scale(p, xfact=scale, yfact=scale, origin=(0, 0))
                p_moved  = translate(p_scaled, yoff=y_offset)
                if not p_moved.is_empty:
                    all_polys.append(p_moved)

    if not all_polys:
        raise RuntimeError(f"No geometry produced for: {params.text!r}")

    # Union all letter polygons into one shape
    text_shape = unary_union(all_polys)
    if text_shape.is_empty:
        raise RuntimeError("Text union produced empty geometry")

    # Bounding box
    bx0, by0, bx1, by1 = text_shape.bounds
    pad   = params.base_padding_mm
    base_rect = Polygon([
        (bx0 - pad, by0 - pad),
        (bx1 + pad, by0 - pad),
        (bx1 + pad, by1 + pad),
        (bx0 - pad, by1 + pad),
    ])

    # Build meshes
    meshes = []

    if params.base:
        base_mesh = _extrude(base_rect, params.base_thickness_mm)
        meshes.append(base_mesh)

        if params.mode == "emboss":
            text_mesh = _extrude(text_shape, params.extrude_depth_mm)
            text_mesh.apply_translation([0, 0, params.base_thickness_mm])
            meshes.append(text_mesh)

        else:  # engrave — subtract text from base
            cutter = _extrude(text_shape, params.extrude_depth_mm + 0.1)
            cutter.apply_translation([0, 0, params.base_thickness_mm - params.extrude_depth_mm])
            combined = trimesh.util.concatenate([base_mesh, cutter])
            # Use manifold boolean if available, otherwise fall back to emboss
            try:
                result = trimesh.boolean.difference([base_mesh, cutter], engine="manifold")
                if result is not None and not result.is_empty:
                    meshes = [result]
                else:
                    raise ValueError("empty result")
            except Exception as exc:
                log.warning("Boolean difference unavailable (%s) — falling back to emboss", exc)
                meshes = [base_mesh]
                text_mesh = _extrude(text_shape, params.extrude_depth_mm)
                text_mesh.apply_translation([0, 0, params.base_thickness_mm])
                meshes.append(text_mesh)

    else:
        text_mesh = _extrude(text_shape, params.extrude_depth_mm)
        meshes.append(text_mesh)

    final = trimesh.util.concatenate(meshes) if len(meshes) > 1 else meshes[0]

    # Center XY on origin (nicer for projection preview)
    cx = (bx0 + bx1) / 2
    cy = (by0 + by1) / 2
    final.apply_translation([-cx, -cy, 0])

    os.makedirs(os.path.dirname(os.path.abspath(output_path)), exist_ok=True)
    final.export(output_path)

    kb   = os.path.getsize(output_path) / 1024
    tris = len(final.faces)
    log.info("Text2STL done: %s  (%.1f KB, %d triangles)", output_path, kb, tris)
    return output_path


def _extrude(shape, height: float) -> trimesh.Trimesh:
    """Extrude a shapely Polygon or MultiPolygon to a trimesh solid."""
    if isinstance(shape, MultiPolygon):
        parts = [_extrude_one(g, height) for g in shape.geoms if not g.is_empty]
        return trimesh.util.concatenate(parts)
    return _extrude_one(shape, height)


def _extrude_one(poly: Polygon, height: float) -> trimesh.Trimesh:
    try:
        return trimesh.creation.extrude_polygon(poly, height)
    except Exception:
        fixed = poly.buffer(0)
        return trimesh.creation.extrude_polygon(fixed, height)


# ─── Public convenience entry point ──────────────────────────────────────────

def generate(
    text: str,
    output_path: str,
    font_size_mm: float         = 10.0,
    extrude_depth_mm: float     = 3.0,
    width_mm: Optional[float]   = None,
    height_mm: Optional[float]  = None,
    base: bool                  = True,
    base_thickness_mm: float    = 2.0,
    base_padding_mm: float      = 3.0,
    mode: str                   = "emboss",
    font_path: Optional[str]    = None,
) -> str:
    if height_mm:
        font_size_mm = (height_mm - base_padding_mm * 2) * 0.75

    params = Text2STLParams(
        text             = text,
        font_path        = font_path,
        font_size_mm     = max(1.0, font_size_mm),
        extrude_depth_mm = extrude_depth_mm,
        base             = base,
        base_thickness_mm= base_thickness_mm,
        base_padding_mm  = base_padding_mm,
        mode             = mode,
    )
    return generate_text_stl(params, output_path)
