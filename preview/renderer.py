"""
STL renderer.

Loads an STL file using numpy-stl and renders it to a numpy BGR frame
using a simple orthographic projection. Applies current scale and rotation
from the state machine context.
"""

import math
import numpy as np

from stl import mesh as stl_mesh

from utils.logger import get_logger

log = get_logger(__name__)


def load_stl(stl_path: str) -> stl_mesh.Mesh:
    return stl_mesh.Mesh.from_file(stl_path)


def render_frame(
    model: stl_mesh.Mesh,
    width: int,
    height: int,
    scale: float = 1.0,
    rotation_deg: float = 0.0,
    bg_color: tuple = (10, 10, 10),
    line_color: tuple = (0, 220, 120),
) -> np.ndarray:
    """
    Render a wireframe projection of the STL model into a (height, width, 3) BGR frame.

    The model is auto-centered and scaled to fit ~70% of the frame, then the
    user's scale/rotation adjustments are applied on top.
    """
    frame = np.full((height, width, 3), bg_color, dtype=np.uint8)

    # Gather all vertices
    verts = model.vectors.reshape(-1, 3).astype(float)

    # Center
    center = verts.mean(axis=0)
    verts -= center

    # Auto-scale to fit 70% of the smaller screen dimension
    extent = np.abs(verts).max()
    if extent == 0:
        extent = 1
    fit_scale = (min(width, height) * 0.35) / extent

    # Apply user rotation around Z axis (desk projection = top-down view)
    rad = math.radians(rotation_deg)
    cos_r, sin_r = math.cos(rad), math.sin(rad)
    rot_matrix = np.array([
        [cos_r, -sin_r, 0],
        [sin_r,  cos_r, 0],
        [0,      0,     1],
    ])
    verts = verts @ rot_matrix.T

    # Apply fit + user scale, then project to 2D (ignore Z for ortho top-down)
    total_scale = fit_scale * scale
    cx, cy = width // 2, height // 2

    # Rebuild triangles after transform
    tris = (model.vectors - center) @ rot_matrix.T
    tris_2d = tris[:, :, :2] * total_scale
    tris_2d[:, :, 0] += cx
    tris_2d[:, :, 1] += cy

    # Draw wireframe triangles
    import cv2
    for tri in tris_2d:
        pts = tri.astype(np.int32)
        for i in range(3):
            p1 = tuple(pts[i])
            p2 = tuple(pts[(i + 1) % 3])
            cv2.line(frame, p1, p2, line_color, 1, cv2.LINE_AA)

    return frame
