"""
DAVIS Preview Test

Type a description  ENTER  real 3D model generates  preview appears.
Type "show me ..." or "find ..." to open gallery mode.

Generate mode examples:
    box
    box 6cm wide 4cm tall
    cylinder 30mm diameter 50mm tall
    hook
    bracket 5cm wide
    ring 40mm diameter

Gallery mode examples:
    show me vase models
    find a hook
    search bracket designs

Controls (Generate mode):
    Type description    update input
    ENTER               generate model
    Drag mouse          rotate
    Scroll wheel        scale
    <- ->               rotate Z
    Up Down             tilt X
    = / -               scale
    R                   reset view
    ESC                 quit

Controls (Gallery mode):
    LEFT / RIGHT        previous / next model
    ENTER               select model  (goes to print config)
    ESC                 back to generate mode

Controls (Print config):
    UP / DOWN           move between fields
    LEFT / RIGHT        change field value
    ENTER               confirm and print
    ESC                 back to gallery
"""

import argparse
import math
import os
import sys
import threading
import time
from enum import Enum, auto

import cv2
import numpy as np
import pygame

sys.path.insert(0, os.path.dirname(__file__))

from generation.model_gen import parse_description, generate as gen_shape, ModelIntent
from generation.model_search import search as tv_search, load_thumbnail, start_stl_download, ThingResult
from stl import mesh as stl_mesh

try:
    import config
    _TOKEN = getattr(config, "THINGIVERSE_TOKEN", "")
except Exception:
    _TOKEN = ""


# ─── Args ─────────────────────────────────────────────────────────────────────

def parse_args():
    p = argparse.ArgumentParser()
    p.add_argument("--width",      type=int, default=1280)
    p.add_argument("--height",     type=int, default=720)
    p.add_argument("--fullscreen", action="store_true")
    return p.parse_args()


# ─── App modes ────────────────────────────────────────────────────────────────

class AppMode(Enum):
    GENERATE  = auto()
    GALLERY   = auto()
    PRINT_CFG = auto()


# ─── Gallery intent detection ─────────────────────────────────────────────────

_GALLERY_TRIGGERS = [
    "show me", "showcase", "find a", "find me", "search for",
    "search ", "browse", "look for", "show some", "give me",
    "models of", "models for", "3d models",
]

def is_gallery_intent(text):
    """Return the search query string if gallery intent detected, else None."""
    t = text.strip().lower()
    for trigger in _GALLERY_TRIGGERS:
        if t.startswith(trigger):
            q = t[len(trigger):].strip()
            for filler in (" models", " model", " designs", " design",
                           " 3d", " stl", " files"):
                if q.endswith(filler):
                    q = q[:-len(filler)].strip()
            return q if q else t
    return None


# ─── Print config fields ──────────────────────────────────────────────────────

CFG_FIELDS = [
    ("Printer",      ["Bambu A1", "Bambu P1S", "Bambu X1C", "Bambu A1 Mini",
                      "Prusa MK4", "Ender 3 V3"], 0),
    ("Filament",     ["PLA", "PETG", "ABS", "TPU", "ASA", "PLA+", "SILK PLA"], 0),
    ("Layer Height", ["0.08mm", "0.12mm", "0.16mm", "0.20mm",
                      "0.24mm", "0.28mm", "0.32mm"], 3),
    ("Infill",       ["5%", "10%", "15%", "20%", "30%",
                      "40%", "50%", "75%", "100%"], 3),
    ("Supports",     ["None", "Auto (touching bed)",
                      "Auto (everywhere)", "Manual"], 1),
    ("Orientation",  ["Auto", "Flat", "Upright", "Side"], 0),
    ("Copies",       [str(i) for i in range(1, 11)], 0),
]


def build_print_config():
    return {name: idx for name, opts, idx in CFG_FIELDS}


# ─── 3D renderer ──────────────────────────────────────────────────────────────

def render_frame(model, W, H, scale, rot_z, rot_x):
    frame = np.full((H, W, 3), (10, 10, 10), dtype=np.uint8)

    verts  = model.vectors.reshape(-1, 3).astype(float)
    center = verts.mean(axis=0)
    extent = np.abs(verts - center).max() or 1.0
    fit    = (min(W, H) * 0.40) / extent

    rz = math.radians(rot_z)
    rx = math.radians(rot_x)
    Rz = np.array([[math.cos(rz), -math.sin(rz), 0],
                   [math.sin(rz),  math.cos(rz), 0],
                   [0,             0,             1]])
    Rx = np.array([[1, 0,             0            ],
                   [0, math.cos(rx), -math.sin(rx) ],
                   [0, math.sin(rx),  math.cos(rx) ]])
    R = Rz @ Rx

    tris     = model.vectors - center
    tris_rot = tris @ R.T
    total    = fit * scale
    cx, cy   = W // 2, H // 2

    sx = (tris_rot[:, :, 0] * total + cx).astype(np.float32)
    sy = (-tris_rot[:, :, 2] * total + cy).astype(np.float32)

    depths = tris_rot[:, :, 1].mean(axis=1)
    d_min, d_max = depths.min(), depths.max() + 1e-9

    v0 = tris_rot[:, 1] - tris_rot[:, 0]
    v1 = tris_rot[:, 2] - tris_rot[:, 0]
    normals = np.cross(v0, v1)
    norms   = np.linalg.norm(normals, axis=1, keepdims=True) + 1e-9
    normals = normals / norms
    light   = np.array([0.4, -1.0, 0.6])
    light  /= np.linalg.norm(light)
    diffuse = np.clip(np.dot(normals, light), 0, 1)

    for i in np.argsort(depths)[::-1]:
        pts = np.stack([sx[i], sy[i]], axis=1).astype(np.int32)
        amb = 0.25
        lit = amb + (1 - amb) * diffuse[i]
        r   = int(lit * 40)
        g   = int(lit * 180)
        b   = int(lit * 90)
        cv2.fillPoly(frame, [pts], (b, g, r))
        for j in range(3):
            cv2.line(frame, tuple(pts[j]), tuple(pts[(j+1) % 3]),
                     (0, 220, 110), 1, cv2.LINE_AA)
    return frame


# ─── HUD constants ────────────────────────────────────────────────────────────

FONT     = cv2.FONT_HERSHEY_SIMPLEX
C_GREEN  = (0, 220, 120)
C_WHITE  = (255, 255, 255)
C_GRAY   = (150, 150, 150)
C_YELLOW = (0, 220, 220)
C_RED    = (80, 80, 220)
C_DARK   = (18, 18, 18)
C_BOX    = (32, 32, 32)
C_DIM    = (60, 60, 60)


# ─── Shared helpers ───────────────────────────────────────────────────────────

def put_centered(frame, text, cx, y, scale, color, thickness=1):
    tw = cv2.getTextSize(text, FONT, scale, thickness)[0][0]
    cv2.putText(frame, text, (cx - tw // 2, y),
                FONT, scale, color, thickness, cv2.LINE_AA)


def draw_top_bar(frame, subtitle, status, status_color):
    H, W = frame.shape[:2]
    cv2.rectangle(frame, (0, 0), (W, 42), C_DARK, -1)
    cv2.putText(frame, "DAVIS", (12, 28), FONT, 0.85, C_GREEN, 2, cv2.LINE_AA)
    cv2.putText(frame, subtitle, (85, 28), FONT, 0.55, C_GRAY, 1, cv2.LINE_AA)
    if status:
        sw = cv2.getTextSize(status, FONT, 0.52, 1)[0][0]
        cv2.putText(frame, status, (W // 2 - sw // 2, 28),
                    FONT, 0.52, status_color, 1, cv2.LINE_AA)


def draw_input_bar(frame, input_text, cursor_on, generating, btn_label=None):
    H, W = frame.shape[:2]
    box_y = H - 138
    cv2.rectangle(frame, (0, box_y - 4), (W, box_y + 50), C_DARK, -1)
    cv2.putText(frame, "DESCRIBE:", (10, box_y + 30), FONT, 0.55, C_GRAY, 1, cv2.LINE_AA)
    field_x = 105
    border_c = C_YELLOW if generating else C_GREEN
    cv2.rectangle(frame, (field_x, box_y), (W - 168, box_y + 42), C_BOX, -1)
    cv2.rectangle(frame, (field_x, box_y), (W - 168, box_y + 42), border_c, 1)
    display = input_text + ("|" if cursor_on else " ")
    cv2.putText(frame, display, (field_x + 8, box_y + 28),
                FONT, 0.65, C_WHITE, 1, cv2.LINE_AA)
    if btn_label is None:
        btn_label = "GENERATING..." if generating else "ENTER = GENERATE"
    btn_c = C_YELLOW if generating else C_GREEN
    cv2.rectangle(frame, (W - 162, box_y + 3), (W - 4, box_y + 39), C_BOX, -1)
    cv2.rectangle(frame, (W - 162, box_y + 3), (W - 4, box_y + 39), btn_c, 1)
    cv2.putText(frame, btn_label, (W - 158, box_y + 26),
                FONT, 0.37, btn_c, 1, cv2.LINE_AA)


# ─── Generate-mode drawing ────────────────────────────────────────────────────

def draw_hud(frame, input_text, cursor_on, scale, rot_z, rot_x,
             status, status_color, model_info, generating):
    H, W = frame.shape[:2]
    draw_top_bar(frame, "PREVIEW TEST", status, status_color)
    draw_input_bar(frame, input_text, cursor_on, generating)

    info_y = H - 86
    cv2.rectangle(frame, (0, info_y), (W, H), C_DARK, -1)
    if model_info:
        cv2.putText(frame, f"Scale {scale * 100:.0f}%",
                    (10, info_y + 18), FONT, 0.48, C_GREEN, 1, cv2.LINE_AA)
        cv2.putText(frame, f"Z {rot_z % 360:.0f}deg  X {rot_x % 360:.0f}deg",
                    (10, info_y + 36), FONT, 0.48, C_GREEN, 1, cv2.LINE_AA)
        cv2.putText(frame, model_info, (10, info_y + 54),
                    FONT, 0.40, C_GRAY, 1, cv2.LINE_AA)
    hints = ["Drag  Rotate", "Scroll  Scale",
             "<- ->  Rotate  Up Dn  Tilt", "=/-  Scale  R  Reset"]
    for i, h in enumerate(hints):
        cv2.putText(frame, h, (W - 200, info_y + 16 + i * 18),
                    FONT, 0.38, C_GRAY, 1, cv2.LINE_AA)


def draw_spinner(frame, text, tick):
    H, W = frame.shape[:2]
    overlay = frame.copy()
    cv2.rectangle(overlay, (0, 0), (W, H), (0, 0, 0), -1)
    cv2.addWeighted(overlay, 0.6, frame, 0.4, 0, frame)
    dots = "." * (tick % 4 + 1)
    msg  = f"Generating  \"{text}\"{dots}"
    mw   = cv2.getTextSize(msg, FONT, 0.8, 1)[0][0]
    cv2.putText(frame, msg, (W // 2 - mw // 2, H // 2 - 8),
                FONT, 0.8, C_GREEN, 1, cv2.LINE_AA)
    sub = "trimesh  ->  STL"
    sw  = cv2.getTextSize(sub, FONT, 0.45, 1)[0][0]
    cv2.putText(frame, sub, (W // 2 - sw // 2, H // 2 + 26),
                FONT, 0.45, C_GRAY, 1, cv2.LINE_AA)


def draw_idle(frame, W, H):
    frame[:] = (10, 10, 10)
    lines = [
        ("DAVIS  MODEL PREVIEW",               0.95, C_GREEN,       H // 2 - 80),
        ("Describe any object and press ENTER", 0.55, C_GRAY,        H // 2 - 30),
        ("box   cylinder   hook   bracket   ring   stand",
         0.48, (80, 140, 80), H // 2 + 20),
        ("wedge   pyramid   sphere   cone   cross   hex",
         0.48, (80, 140, 80), H // 2 + 48),
        ("Add dimensions:  box 6cm wide 3cm tall",
         0.44, C_GRAY, H // 2 + 80),
        ("Or try gallery:  show me vase models",
         0.44, (60, 180, 80), H // 2 + 105),
    ]
    for txt, sz, col, y in lines:
        if not txt:
            continue
        tw = cv2.getTextSize(txt, FONT, sz, 1)[0][0]
        cv2.putText(frame, txt, (W // 2 - tw // 2, y),
                    FONT, sz, col, 1, cv2.LINE_AA)


# ─── Gallery mode drawing ─────────────────────────────────────────────────────

def draw_gallery(frame, results, idx, loading, query, tick, input_text, cursor_on):
    H, W = frame.shape[:2]
    frame[:] = (12, 12, 18)

    if loading:
        status = f"Searching for \"{query}\"..."
    elif results:
        status = f"{len(results)} results for \"{query}\""
    else:
        status = f"No results for \"{query}\""

    draw_top_bar(frame, "GALLERY", status, C_GRAY)
    draw_input_bar(frame, input_text, cursor_on, False, "ENTER = SELECT")

    CONTENT_TOP = 52
    CONTENT_BOT = H - 145

    if loading:
        dots = "." * (tick % 4 + 1)
        msg  = f"Searching{dots}"
        put_centered(frame, msg, W // 2, (CONTENT_TOP + CONTENT_BOT) // 2,
                     0.9, C_GREEN)
        return

    if not results:
        put_centered(frame, "No results found",
                     W // 2, (CONTENT_TOP + CONTENT_BOT) // 2, 0.8, C_GRAY)
        put_centered(frame, "Try a different search term",
                     W // 2, (CONTENT_TOP + CONTENT_BOT) // 2 + 36, 0.5, C_GRAY)
        return

    CY = (CONTENT_TOP + CONTENT_BOT) // 2

    CARD_W_MAIN = min(400, W // 3)
    CARD_H_MAIN = int(CARD_W_MAIN * 0.75)
    CARD_W_SIDE = int(CARD_W_MAIN * 0.55)
    CARD_H_SIDE = int(CARD_W_SIDE * 0.75)
    GAP = 22

    def draw_card(result, cx, cy, cw, ch, dimmed):
        x0 = cx - cw // 2
        y0 = cy - ch // 2
        if x0 < 0 or x0 + cw > W or y0 < 0 or y0 + ch > H:
            return

        thumb_h = ch - 24
        thumb = load_thumbnail(result, cw, thumb_h)
        if thumb is not None:
            th   = min(thumb.shape[0], ch - 24)
            tw_p = min(thumb.shape[1], cw)
            fy0 = y0
            fy1 = y0 + th
            fx0 = cx - tw_p // 2
            fx1 = fx0 + tw_p
            if fy0 >= 0 and fy1 <= H and fx0 >= 0 and fx1 <= W:
                frame[fy0:fy1, fx0:fx1] = thumb[:th, :tw_p]

        if dimmed:
            overlay = frame.copy()
            cv2.rectangle(overlay, (x0, y0), (x0 + cw, y0 + ch), (0, 0, 0), -1)
            cv2.addWeighted(overlay, 0.55, frame, 0.45, 0, frame)

        strip_y = y0 + ch - 24
        cv2.rectangle(frame, (x0, strip_y), (x0 + cw, y0 + ch), (20, 20, 20), -1)
        name = result.name[:28]
        nw = cv2.getTextSize(name, FONT, 0.38, 1)[0][0]
        nc = C_WHITE if not dimmed else C_GRAY
        cv2.putText(frame, name, (cx - nw // 2, strip_y + 16),
                    FONT, 0.38, nc, 1, cv2.LINE_AA)

        bc    = C_GREEN if not dimmed else C_DIM
        thick = 2 if not dimmed else 1
        cv2.rectangle(frame, (x0, y0), (x0 + cw, y0 + ch), bc, thick)

    main_cx  = W // 2
    left_cx  = main_cx - CARD_W_MAIN // 2 - CARD_W_SIDE // 2 - GAP
    right_cx = main_cx + CARD_W_MAIN // 2 + CARD_W_SIDE // 2 + GAP

    if idx > 0:
        draw_card(results[idx - 1], left_cx, CY, CARD_W_SIDE, CARD_H_SIDE, True)
    if idx < len(results) - 1:
        draw_card(results[idx + 1], right_cx, CY, CARD_W_SIDE, CARD_H_SIDE, True)
    draw_card(results[idx], main_cx, CY, CARD_W_MAIN, CARD_H_MAIN, False)

    r = results[idx]
    info_y = CY + CARD_H_MAIN // 2 + 22
    put_centered(frame, r.name, main_cx, info_y, 0.55, C_WHITE, 1)
    put_centered(frame, f"by {r.creator}   {r.likes} likes",
                 main_cx, info_y + 22, 0.42, C_GRAY)

    # Pagination dots
    dots_y     = info_y + 46
    n          = min(len(results), 20)
    dot_gap    = 12
    dx_start   = W // 2 - n * dot_gap // 2
    for di in range(n):
        col  = C_GREEN if di == idx else C_DIM
        size = 4 if di == idx else 3
        cv2.circle(frame, (dx_start + di * dot_gap, dots_y), size, col, -1)

    hint_y = H - 95
    put_centered(frame, "<-  Previous       ENTER = Select       Next  ->",
                 W // 2, hint_y, 0.42, C_GRAY)
    put_centered(frame, "ESC = back to generate mode",
                 W // 2, hint_y + 20, 0.38, C_DIM)


# ─── Print config drawing ─────────────────────────────────────────────────────

def draw_print_cfg(frame, result, cfg, field_idx, confirming, status, status_color):
    H, W = frame.shape[:2]
    frame[:] = (12, 12, 18)

    draw_top_bar(frame, "PRINT CONFIG", status, status_color)

    CONTENT_TOP = 52
    LEFT_W = W // 2 - 20

    # Thumbnail
    thumb_h = 220
    thumb_w = min(LEFT_W - 20, int(thumb_h * 1.33))
    thumb = load_thumbnail(result, thumb_w, thumb_h)
    if thumb is not None:
        tx = 10 + (LEFT_W - thumb_w) // 2
        ty = CONTENT_TOP + 10
        th = min(thumb.shape[0], thumb_h)
        tw = min(thumb.shape[1], thumb_w)
        if ty + th <= H and tx + tw <= W:
            frame[ty:ty + th, tx:tx + tw] = thumb[:th, :tw]

    # Model info
    info_y = CONTENT_TOP + thumb_h + 24
    put_centered(frame, result.name[:32], LEFT_W // 2 + 10, info_y, 0.55, C_WHITE)
    put_centered(frame, f"by {result.creator}",
                 LEFT_W // 2 + 10, info_y + 22, 0.42, C_GRAY)
    put_centered(frame, f"{result.likes} likes",
                 LEFT_W // 2 + 10, info_y + 42, 0.40, C_GRAY)
    url_lbl = f"thing:{result.thing_id}"
    put_centered(frame, url_lbl, LEFT_W // 2 + 10, info_y + 62, 0.36, (80, 140, 80))

    # Divider
    cv2.line(frame, (W // 2, CONTENT_TOP), (W // 2, H - 60), C_DIM, 1)

    # Form fields (right half)
    FX      = W // 2 + 20
    FY      = CONTENT_TOP + 30
    F_ROW_H = max(30, (H - 120 - FY) // len(CFG_FIELDS))

    for fi, (name, opts, default_idx) in enumerate(CFG_FIELDS):
        val_idx = cfg.get(name, default_idx)
        val     = opts[val_idx]
        y       = FY + fi * F_ROW_H
        active  = fi == field_idx

        row_col = (40, 40, 60) if active else C_BOX
        cv2.rectangle(frame, (FX - 4, y - 2), (W - 8, y + F_ROW_H - 6), row_col, -1)
        if active:
            cv2.rectangle(frame, (FX - 4, y - 2), (W - 8, y + F_ROW_H - 6), C_GREEN, 1)

        lbl_col = C_GREEN if active else C_GRAY
        cv2.putText(frame, name, (FX, y + 14), FONT, 0.42, lbl_col, 1, cv2.LINE_AA)

        val_x = FX + 140
        if active:
            cv2.putText(frame, "<", (val_x - 18, y + 14),
                        FONT, 0.42, C_YELLOW, 1, cv2.LINE_AA)
        cv2.putText(frame, val, (val_x + 4, y + 14), FONT, 0.50, C_WHITE, 1, cv2.LINE_AA)
        if active:
            vw = cv2.getTextSize(val, FONT, 0.50, 1)[0][0]
            cv2.putText(frame, ">", (val_x + vw + 12, y + 14),
                        FONT, 0.42, C_YELLOW, 1, cv2.LINE_AA)

    # Bottom hint bar
    bar_y = H - 58
    cv2.rectangle(frame, (0, bar_y), (W, H), C_DARK, -1)
    if confirming:
        put_centered(frame, "Sending to printer...", W // 2, bar_y + 26, 0.65, C_YELLOW)
    else:
        hints = "UP/DOWN  Move field    LEFT/RIGHT  Change value    ENTER  Print    ESC  Back"
        put_centered(frame, hints, W // 2, bar_y + 22, 0.38, C_GRAY)


# ─── STL save ─────────────────────────────────────────────────────────────────

def save_stl(mesh_trimesh, description):
    out_dir = os.path.join(os.path.dirname(__file__), "generation", "stl_cache")
    os.makedirs(out_dir, exist_ok=True)
    slug = description[:20].replace(" ", "_").replace("/", "-")
    path = os.path.join(out_dir, f"model_{slug}_{int(time.time())}.stl")
    mesh_trimesh.export(path)
    return path


# ─── Main ─────────────────────────────────────────────────────────────────────

def main():
    args = parse_args()

    pygame.init()
    flags  = pygame.FULLSCREEN if args.fullscreen else pygame.RESIZABLE
    screen = pygame.display.set_mode((args.width, args.height), flags)
    pygame.display.set_caption("DAVIS Preview Test")
    clock  = pygame.time.Clock()

    # Generate-mode state
    mode         = AppMode.GENERATE
    input_text   = ""
    model        = None
    model_info   = ""
    scale        = 1.0
    rot_z        = -35.0
    rot_x        = 25.0
    status       = "Describe an object and press ENTER"
    status_color = C_GRAY
    generating   = False
    gen_result   = {}
    dragging     = False
    drag_last    = (0, 0)
    tick         = 0
    cursor_tick  = 0

    # Gallery state
    gallery_results = []
    gallery_idx     = 0
    gallery_loading = False
    gallery_query   = ""

    # Print config state
    cfg_result     = None
    cfg_values     = build_print_config()
    cfg_field_idx  = 0
    cfg_confirming = False
    cfg_status     = ""
    cfg_status_col = C_GRAY

    # Timer to auto-return from print confirm
    return_to_gallery_at = None

    # ── Helper: start generate ────────────────────────────────────────────────
    def start_gen(text):
        nonlocal generating, gen_result, status, status_color
        if not text.strip() or generating:
            return
        intent = parse_description(text)
        if intent is None:
            status       = f"Unknown shape: \"{text[:40]}\"  try: box, hook, bracket..."
            status_color = C_RED
            return
        generating  = True
        gen_result  = {}
        status      = ""

        def _run():
            t0 = time.time()
            try:
                mesh     = gen_shape(intent)
                stl_path = save_stl(mesh, text)
                gen_result["mesh"]    = mesh
                gen_result["path"]    = stl_path
                gen_result["intent"]  = intent
                gen_result["elapsed"] = time.time() - t0
            except Exception as exc:
                gen_result["error"] = str(exc)
            finally:
                gen_result["done"] = True

        threading.Thread(target=_run, daemon=True).start()

    # ── Helper: gallery search ────────────────────────────────────────────────
    def start_gallery_search(query):
        nonlocal gallery_loading, gallery_results, gallery_idx, gallery_query
        gallery_loading = True
        gallery_results = []
        gallery_idx     = 0
        gallery_query   = query

        def _run():
            nonlocal gallery_loading, gallery_results
            try:
                gallery_results = tv_search(query, token=_TOKEN, per_page=20)
            except Exception as exc:
                print(f"[gallery] search error: {exc}")
                gallery_results = []
            gallery_loading = False

        threading.Thread(target=_run, daemon=True).start()

    def enter_gallery(query):
        nonlocal mode
        mode = AppMode.GALLERY
        start_gallery_search(query)

    # ── Helper: select gallery item → print config ────────────────────────────
    def select_gallery_item():
        nonlocal mode, cfg_result, cfg_values, cfg_field_idx
        nonlocal cfg_confirming, cfg_status, cfg_status_col
        if not gallery_results:
            return
        r = gallery_results[gallery_idx]
        cfg_result     = r
        cfg_values     = build_print_config()
        cfg_field_idx  = 0
        cfg_confirming = False
        cfg_status     = f"Configure: {r.name[:36]}"
        cfg_status_col = C_GRAY
        mode = AppMode.PRINT_CFG
        start_stl_download(r, token=_TOKEN)

    # ── Helper: confirm print ─────────────────────────────────────────────────
    def do_print():
        nonlocal cfg_confirming, cfg_status, cfg_status_col, return_to_gallery_at
        if cfg_result is None:
            return
        cfg_confirming       = True
        cfg_status           = f"Print queued: {cfg_result.name[:40]}"
        cfg_status_col       = C_GREEN
        return_to_gallery_at = time.time() + 2.0

        summary = {name: opts[cfg_values.get(name, idx)]
                   for name, opts, idx in CFG_FIELDS}
        print(f"\n[PRINT JOB]  {cfg_result.name}")
        print(f"  URL: {cfg_result.thing_url}")
        for k, v in summary.items():
            print(f"  {k}: {v}")
        print(f"  STL: {cfg_result.stl_path or '(downloading...)'}")

    # ── Main loop ─────────────────────────────────────────────────────────────
    while True:
        W, H = screen.get_size()

        # Auto-return from print confirm
        if return_to_gallery_at and time.time() >= return_to_gallery_at:
            return_to_gallery_at = None
            mode           = AppMode.GALLERY
            cfg_confirming = False

        # Generation result
        if generating and gen_result.get("done"):
            generating = False
            if "error" in gen_result:
                status       = f"Error: {gen_result['error'][:70]}"
                status_color = C_RED
                print(f"Generation error: {gen_result['error']}")
            else:
                stl_path  = gen_result["path"]
                tm_mesh   = gen_result["mesh"]
                intent    = gen_result["intent"]
                elapsed   = gen_result["elapsed"]
                model     = stl_mesh.Mesh.from_file(stl_path)
                scale, rot_z, rot_x = 1.0, -35.0, 25.0
                kb        = os.path.getsize(stl_path) / 1024
                tris      = len(tm_mesh.faces)
                model_info = (f"{intent.shape}  "
                              f"{intent.width_mm:.0f}x{intent.height_mm:.0f}"
                              f"x{intent.depth_mm:.0f}mm  "
                              f"{tris} tris  {kb:.1f}KB  {elapsed:.2f}s")
                status       = f"Generated: {intent.shape}  ({elapsed:.2f}s)"
                status_color = C_GREEN
                print(f"\nSTL: {stl_path}\n     {model_info}")

        # Events
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                return

            elif event.type == pygame.KEYDOWN:
                k = event.key

                # ESC always goes back one level
                if k == pygame.K_ESCAPE:
                    if mode == AppMode.PRINT_CFG:
                        mode = AppMode.GALLERY
                    elif mode == AppMode.GALLERY:
                        mode = AppMode.GENERATE
                    else:
                        pygame.quit()
                        return

                # GENERATE mode keys
                elif mode == AppMode.GENERATE:
                    if k == pygame.K_RETURN:
                        q = is_gallery_intent(input_text)
                        if q is not None:
                            enter_gallery(q)
                        else:
                            start_gen(input_text)
                    elif k == pygame.K_BACKSPACE:
                        input_text = input_text[:-1]
                    elif k == pygame.K_r and not event.mod:
                        scale, rot_z, rot_x = 1.0, -35.0, 25.0
                    elif k == pygame.K_LEFT:  rot_z -= 3.0
                    elif k == pygame.K_RIGHT: rot_z += 3.0
                    elif k == pygame.K_UP:    rot_x -= 3.0
                    elif k == pygame.K_DOWN:  rot_x += 3.0
                    elif k in (pygame.K_EQUALS, pygame.K_KP_PLUS):
                        scale = min(5.0, scale + 0.1)
                    elif k in (pygame.K_MINUS, pygame.K_KP_MINUS):
                        scale = max(0.1, scale - 0.1)
                    else:
                        ch = event.unicode
                        if ch and ch.isprintable() and len(input_text) < 60:
                            input_text += ch

                # GALLERY mode keys
                elif mode == AppMode.GALLERY:
                    if k == pygame.K_RETURN:
                        q = is_gallery_intent(input_text)
                        if q is not None:
                            start_gallery_search(q)
                        else:
                            select_gallery_item()
                    elif k == pygame.K_LEFT:
                        gallery_idx = max(0, gallery_idx - 1)
                    elif k == pygame.K_RIGHT:
                        if gallery_results:
                            gallery_idx = min(len(gallery_results) - 1,
                                              gallery_idx + 1)
                    elif k == pygame.K_BACKSPACE:
                        input_text = input_text[:-1]
                    else:
                        ch = event.unicode
                        if ch and ch.isprintable() and len(input_text) < 60:
                            input_text += ch

                # PRINT CONFIG mode keys
                elif mode == AppMode.PRINT_CFG:
                    if k == pygame.K_RETURN and not cfg_confirming:
                        do_print()
                    elif k == pygame.K_UP:
                        cfg_field_idx = (cfg_field_idx - 1) % len(CFG_FIELDS)
                    elif k == pygame.K_DOWN:
                        cfg_field_idx = (cfg_field_idx + 1) % len(CFG_FIELDS)
                    elif k == pygame.K_LEFT:
                        name, opts, default_idx = CFG_FIELDS[cfg_field_idx]
                        cur = cfg_values.get(name, default_idx)
                        cfg_values[name] = (cur - 1) % len(opts)
                    elif k == pygame.K_RIGHT:
                        name, opts, default_idx = CFG_FIELDS[cfg_field_idx]
                        cur = cfg_values.get(name, default_idx)
                        cfg_values[name] = (cur + 1) % len(opts)

            # Mouse events
            elif event.type == pygame.MOUSEBUTTONDOWN and event.button == 1:
                dragging = True
                drag_last = event.pos
            elif event.type == pygame.MOUSEBUTTONUP and event.button == 1:
                if mode == AppMode.GALLERY and dragging:
                    dx = event.pos[0] - drag_last[0]
                    if dx < -60 and gallery_results:
                        gallery_idx = min(len(gallery_results) - 1, gallery_idx + 1)
                    elif dx > 60:
                        gallery_idx = max(0, gallery_idx - 1)
                dragging = False
            elif event.type == pygame.MOUSEMOTION and dragging:
                if mode == AppMode.GENERATE:
                    dx = event.pos[0] - drag_last[0]
                    dy = event.pos[1] - drag_last[1]
                    rot_z += dx * 0.4
                    rot_x += dy * 0.4
                    drag_last = event.pos
            elif event.type == pygame.MOUSEWHEEL:
                if mode == AppMode.GENERATE:
                    scale = max(0.1, min(5.0, scale + event.y * 0.08))

        # ── Render ────────────────────────────────────────────────────────────
        frame     = np.full((H, W, 3), (10, 10, 10), dtype=np.uint8)
        cursor_on = (cursor_tick // 30) % 2 == 0

        if mode == AppMode.GENERATE:
            if model is None and not generating:
                draw_idle(frame, W, H)
            elif model is not None:
                frame = render_frame(model, W, H, scale, rot_z, rot_x)
            if generating:
                draw_spinner(frame, input_text, tick)
            draw_hud(frame, input_text, cursor_on,
                     scale, rot_z, rot_x,
                     status, status_color, model_info, generating)

        elif mode == AppMode.GALLERY:
            draw_gallery(frame, gallery_results, gallery_idx,
                         gallery_loading, gallery_query, tick,
                         input_text, cursor_on)

        elif mode == AppMode.PRINT_CFG:
            if cfg_result is not None:
                draw_print_cfg(frame, cfg_result, cfg_values, cfg_field_idx,
                               cfg_confirming, cfg_status, cfg_status_col)

        surface = pygame.surfarray.make_surface(
            np.transpose(frame[:, :, ::-1], (1, 0, 2))
        )
        screen.blit(surface, (0, 0))
        pygame.display.flip()
        clock.tick(60)
        tick += 1
        cursor_tick += 1


if __name__ == "__main__":
    main()
