"""
DAVIS Model Search  —  Thingiverse API wrapper

Usage
-----
results = search("vase", per_page=20)   # list[ThingResult]
img     = load_thumbnail(result)        # numpy BGR array or None
path    = download_stl(result)          # local path to .stl, blocks until done
future  = start_stl_download(result)    # threading.Thread (non-blocking)

Files are cached under generation/thingiverse_cache/.
If THINGIVERSE_TOKEN is blank the module returns offline mock data so the
UI can be tested without an API key.
"""

from __future__ import annotations

import json
import os
import threading
import time
from dataclasses import dataclass, field
from typing import Optional
import urllib.request
import urllib.parse
import urllib.error

import numpy as np

# Optional cv2 for thumbnail decode — falls back to colour swatch if missing
try:
    import cv2
    _CV2 = True
except ImportError:
    _CV2 = False

# ─── Config ───────────────────────────────────────────────────────────────────

_HERE      = os.path.dirname(os.path.abspath(__file__))
CACHE_DIR  = os.path.join(_HERE, "thingiverse_cache")
API_BASE   = "https://api.thingiverse.com"
_TIMEOUT   = 10   # seconds for HTTP requests

# ─── Data classes ─────────────────────────────────────────────────────────────

@dataclass
class ThingResult:
    thing_id:      int
    name:          str
    creator:       str
    likes:         int
    thumbnail_url: str
    thing_url:     str
    description:   str   = ""
    # filled in after download
    thumbnail_path: Optional[str] = field(default=None, repr=False)
    stl_path:       Optional[str] = field(default=None, repr=False)
    stl_downloading: bool         = field(default=False, repr=False)
    stl_error:      Optional[str] = field(default=None, repr=False)


# ─── Helpers ──────────────────────────────────────────────────────────────────

def _ensure_cache():
    os.makedirs(CACHE_DIR, exist_ok=True)


def _get(url: str, token: str) -> dict:
    req = urllib.request.Request(url)
    req.add_header("Authorization", f"Bearer {token}")
    req.add_header("User-Agent", "DAVIS/1.0")
    with urllib.request.urlopen(req, timeout=_TIMEOUT) as resp:
        return json.loads(resp.read().decode())


def _download_file(url: str, dest: str, token: str = "") -> str:
    """Download url → dest, return dest. Uses bearer token if provided."""
    req = urllib.request.Request(url)
    if token:
        req.add_header("Authorization", f"Bearer {token}")
    req.add_header("User-Agent", "DAVIS/1.0")
    with urllib.request.urlopen(req, timeout=30) as resp:
        data = resp.read()
    with open(dest, "wb") as f:
        f.write(data)
    return dest


# ─── Mock data (no token) ─────────────────────────────────────────────────────

_MOCK_THINGS = [
    ("Voronoi Vase",          "DesignsByJohn",   4821, 12301),
    ("Spiral Vase Mode Vase", "PrintsByMaria",   3102,  9840),
    ("Geometric Vase",        "CreativeMaker",   2788,  7623),
    ("Flower Vase",           "3DGarden",        2311,  6210),
    ("Tall Cylinder Vase",    "MinimalPrints",   1980,  5100),
    ("Ribbed Vase",           "TextureLab",      1745,  4322),
    ("Twisted Column Vase",   "SpiraForm",       1599,  3900),
    ("Low Poly Vase",         "PolyArt3D",       1402,  3555),
    ("Wave Vase",             "OceanPrint",      1388,  3210),
    ("Honeycomb Vase",        "HexDesigns",      1200,  2900),
    ("Square Vase",           "SharpLines",       998,  2400),
    ("Bud Vase Set",          "FloralMaker",      888,  2100),
    ("Classical Column Vase", "AntiquePrints",    777,  1900),
    ("Lace Vase",             "FineDetail3D",     699,  1750),
    ("Bulb Vase",             "OrganicForms",     650,  1600),
    ("Tall Slim Vase",        "MinimalistPrint",  601,  1500),
    ("Woven Basket Vase",     "TextileForm",      555,  1400),
    ("Art Deco Vase",         "RetroMaker",       500,  1300),
    ("Rustic Jug Vase",       "CountryStyle3D",   450,  1200),
    ("Vase with Handles",     "ClassicPottery",   400,  1100),
]

_MOCK_COLOURS = [
    (100, 60, 200), (60, 160, 220), (40, 180, 100), (220, 140, 50),
    (200, 80, 80),  (80, 200, 180), (180, 80, 200), (200, 200, 60),
    (60, 100, 200), (200, 120, 60), (80, 200, 100), (200, 60, 140),
    (60, 200, 200), (140, 60, 200), (200, 180, 40), (40, 200, 160),
    (180, 200, 60), (200, 60, 80),  (60, 180, 200), (120, 200, 80),
]


def _make_mock_thumbnail(name: str, colour: tuple[int,int,int],
                          W: int = 400, H: int = 300) -> np.ndarray:
    """Generate a coloured placeholder thumbnail as a BGR numpy array."""
    img = np.zeros((H, W, 3), dtype=np.uint8)
    # Gradient background
    for y in range(H):
        t = y / H
        img[y, :] = [int(c * (0.4 + 0.6 * (1 - t))) for c in colour]

    if _CV2:
        # Vase silhouette outline
        cx = W // 2
        pts = np.array([
            [cx - 30, H - 20],
            [cx - 40, H - 60],
            [cx - 20, H - 100],
            [cx - 35, H - 160],
            [cx - 55, H - 220],
            [cx - 40, H - 260],
            [cx,      H - 280],
            [cx + 40, H - 260],
            [cx + 55, H - 220],
            [cx + 35, H - 160],
            [cx + 20, H - 100],
            [cx + 40, H - 60],
            [cx + 30, H - 20],
        ], dtype=np.int32)
        cv2.fillPoly(img, [pts], (min(255, colour[0]+40),
                                   min(255, colour[1]+40),
                                   min(255, colour[2]+40)))
        cv2.polylines(img, [pts], True, (255, 255, 255), 1, cv2.LINE_AA)

        # Name label at bottom
        cv2.rectangle(img, (0, H-30), (W, H), (0,0,0), -1)
        label = name[:32]
        tw = cv2.getTextSize(label, cv2.FONT_HERSHEY_SIMPLEX, 0.45, 1)[0][0]
        cv2.putText(img, label, (W//2 - tw//2, H-10),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.45, (200,200,200), 1, cv2.LINE_AA)
    return img


def _mock_results(query: str, per_page: int) -> list[ThingResult]:
    results = []
    q = query.lower()
    for i, (name, creator, thing_id, likes) in enumerate(_MOCK_THINGS[:per_page]):
        r = ThingResult(
            thing_id      = thing_id,
            name          = name,
            creator       = creator,
            likes         = likes,
            thumbnail_url = "",
            thing_url     = f"https://www.thingiverse.com/thing:{thing_id}",
            description   = f"A beautiful 3D printable {name.lower()} — perfect for home decor.",
        )
        # Pre-generate mock thumbnail as an array (skip disk cache for mocks)
        colour = _MOCK_COLOURS[i % len(_MOCK_COLOURS)]
        r._mock_thumb = _make_mock_thumbnail(name, colour)   # type: ignore[attr-defined]
        results.append(r)
    return results


# ─── Public API ───────────────────────────────────────────────────────────────

def search(query: str, token: str = "", per_page: int = 20) -> list[ThingResult]:
    """
    Search Thingiverse for `query`. Returns up to per_page ThingResult objects.
    Falls back to offline mock data if token is empty or request fails.
    """
    if not token:
        return _mock_results(query, per_page)

    _ensure_cache()
    encoded = urllib.parse.quote(query)
    url = f"{API_BASE}/search/{encoded}?type=things&per_page={per_page}&sort=relevant"
    try:
        data  = _get(url, token)
        items = data.get("hits", data) if isinstance(data, dict) else data
        results = []
        for item in items[:per_page]:
            r = ThingResult(
                thing_id      = item["id"],
                name          = item.get("name", "Unnamed"),
                creator       = item.get("creator", {}).get("name", "Unknown"),
                likes         = item.get("like_count", 0),
                thumbnail_url = item.get("thumbnail", ""),
                thing_url     = item.get("public_url", ""),
                description   = item.get("description", ""),
            )
            results.append(r)
        return results
    except Exception as exc:
        print(f"[model_search] Thingiverse search failed ({exc}), using mock data")
        return _mock_results(query, per_page)


def load_thumbnail(result: ThingResult,
                   W: int = 400, H: int = 300) -> Optional[np.ndarray]:
    """
    Return thumbnail as BGR numpy array (W x H).
    For mock results returns the pre-generated swatch.
    For real results downloads and caches the image.
    """
    # Mock path — thumbnail already attached as attribute
    if hasattr(result, "_mock_thumb"):
        img = result._mock_thumb   # type: ignore[attr-defined]
        if img.shape[:2] != (H, W):
            if _CV2:
                img = cv2.resize(img, (W, H))
        return img

    if not result.thumbnail_url:
        return _colour_swatch(result.name, W, H)

    # Check disk cache
    cache_name = f"thumb_{result.thing_id}.jpg"
    cache_path = os.path.join(CACHE_DIR, cache_name)

    if not os.path.exists(cache_path):
        try:
            _ensure_cache()
            _download_file(result.thumbnail_url, cache_path)
        except Exception as exc:
            print(f"[model_search] thumbnail download failed: {exc}")
            return _colour_swatch(result.name, W, H)

    result.thumbnail_path = cache_path
    if _CV2:
        img = cv2.imread(cache_path)
        if img is not None:
            return cv2.resize(img, (W, H))
    return _colour_swatch(result.name, W, H)


def _colour_swatch(name: str, W: int, H: int) -> np.ndarray:
    h = hash(name) % len(_MOCK_COLOURS)
    return _make_mock_thumbnail(name, _MOCK_COLOURS[h], W, H)


def start_stl_download(result: ThingResult, token: str = "") -> threading.Thread:
    """
    Begin downloading the first STL file for result in a daemon thread.
    Check result.stl_path (set when done) or result.stl_error (set on failure).
    """
    t = threading.Thread(target=_download_stl_worker,
                         args=(result, token), daemon=True)
    result.stl_downloading = True
    t.start()
    return t


def _download_stl_worker(result: ThingResult, token: str):
    try:
        _ensure_cache()
        cache_path = os.path.join(CACHE_DIR, f"thing_{result.thing_id}.stl")
        if os.path.exists(cache_path):
            result.stl_path = cache_path
            result.stl_downloading = False
            return

        if not token:
            # For mock data: generate a trimesh box as placeholder STL
            _generate_placeholder_stl(result, cache_path)
            result.stl_path = cache_path
            result.stl_downloading = False
            return

        # Get file list
        files_url = f"{API_BASE}/things/{result.thing_id}/files"
        files = _get(files_url, token)
        stl_files = [f for f in files if f.get("name", "").lower().endswith(".stl")]
        if not stl_files:
            raise RuntimeError("No STL files found for this thing")

        stl_url = stl_files[0]["public_url"]
        _download_file(stl_url, cache_path, token)
        result.stl_path = cache_path
    except Exception as exc:
        result.stl_error = str(exc)
    finally:
        result.stl_downloading = False


def _generate_placeholder_stl(result: ThingResult, path: str):
    """Generate a simple vase-like shape as placeholder STL for mock data."""
    try:
        import trimesh
        import trimesh.creation
        from shapely.geometry import Polygon
        import math

        # Build a vase profile: outer shell using lathe rotation
        # Profile points (r, z) from bottom to top
        profile = [
            (12, 0),
            (14, 5),
            (16, 15),
            (20, 35),
            (24, 55),
            (22, 75),
            (18, 90),
            (16, 100),
        ]
        # Create extruded polygon approximation: stack of cylinders
        segments = []
        for i in range(len(profile) - 1):
            r0, z0 = profile[i]
            r1, z1 = profile[i + 1]
            h = z1 - z0
            r_avg = (r0 + r1) / 2
            cyl = trimesh.creation.cylinder(radius=r_avg, height=h, sections=32)
            cyl.apply_translation([0, 0, z0 + h / 2])
            segments.append(cyl)

        mesh = trimesh.util.concatenate(segments)
        mesh.export(path)
    except Exception:
        # Ultra-fallback: just a box
        import trimesh
        mesh = trimesh.creation.box(extents=[30, 30, 80])
        mesh.export(path)
