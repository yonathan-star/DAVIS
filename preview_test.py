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
import glob
import math
import os
import sys
import threading
import time
from enum import Enum, auto


# --- Auto-reload -----------------------------------------------------------

def _start_autoreload():
    """Watch .py files and execv-restart the process when any change."""
    root = os.path.dirname(os.path.abspath(__file__))

    def _mtimes():
        return {f: os.path.getmtime(f)
                for f in glob.glob(os.path.join(root, "**", "*.py"), recursive=True)}

    baseline = _mtimes()

    def _watch():
        while True:
            time.sleep(1)
            current = _mtimes()
            for f, mt in current.items():
                if baseline.get(f) != mt:
                    print(f"\n[reload] {os.path.relpath(f, root)} changed -- restarting...\n")
                    time.sleep(0.3)
                    os.execv(sys.executable, [sys.executable] + sys.argv)

    threading.Thread(target=_watch, daemon=True).start()


if "--no-reload" not in sys.argv:
    _start_autoreload()

import cv2
import numpy as np
import pygame

sys.path.insert(0, os.path.dirname(__file__))

from generation.model_gen import parse_description, generate as gen_shape, ModelIntent
from generation.model_search import search as tv_search, load_thumbnail, start_stl_download, ThingResult
from stl import mesh as stl_mesh
from printer.discovery import load_saved, save_config, apply_to_config, start_discovery

try:
    import config
    _TOKEN = getattr(config, "THINGIVERSE_TOKEN", "")
except Exception:
    _TOKEN = ""

# -- Printer bootstrap: saved config -> live config module ------------------
_printer_cfg = load_saved()   # {"ip","serial","access_code","model"} or None
if _printer_cfg:
    apply_to_config(_printer_cfg)

from printer.bambu_status import get_status as get_bambu_status
_bambu = get_bambu_status()   # None if printer not configured

# -- Multi-printer discovery list -------------------------------------------
_discovered_printers = []


# --- Args ------------------------------------------------------------------

def parse_args():
    p = argparse.ArgumentParser()
    p.add_argument("--width",      type=int, default=1280)
    p.add_argument("--height",     type=int, default=720)
    p.add_argument("--fullscreen", action="store_true")
    p.add_argument("--no-reload",  action="store_true",
                   help="Disable auto-reload watcher")
    return p.parse_args()


# --- App modes -------------------------------------------------------------

class AppMode(Enum):
    GENERATE  = auto()
    GALLERY   = auto()
    PRINT_CFG = auto()
    SETUP     = auto()    # access-code entry after auto-discovery


# --- Gallery intent detection ----------------------------------------------

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


# --- Print config fields ---------------------------------------------------

_CFG_STATIC = [
    ("Layer Height", ["0.08mm", "0.12mm", "0.16mm", "0.20mm",
                      "0.24mm", "0.28mm", "0.32mm"], 3),
    ("Infill",       ["5%", "10%", "15%", "20%", "30%",
                      "40%", "50%", "75%", "100%"], 3),
    ("Supports",     ["None", "Auto (touching bed)",
                      "Auto (everywhere)", "Manual"], 1),
    ("Orientation",  ["Auto", "Flat", "Upright", "Side"], 0),
    ("Copies",       [str(i) for i in range(1, 11)], 0),
]

_CFG_PRINTER_FALLBACK = ["Bambu A1", "Bambu P1S", "Bambu X1C",
                          "Bambu A1 Mini", "Prusa MK4", "Ender 3 V3"]
_CFG_FILAMENT_FALLBACK = ["PLA", "PETG", "ABS", "TPU", "ASA", "PLA+", "SILK PLA"]


def get_cfg_fields():
    """Build CFG_FIELDS dynamically -- uses live printer data if available."""
    if _discovered_printers:
        printer_opts = [d['model'] + ' ' + d['ip'] for d in _discovered_printers]
        printer_idx  = 0
    elif _bambu:
        snap = _bambu.snapshot()
        printer_name = snap.printer_model
        online = "  (online)" if snap.online else "  (connecting...)"
        printer_opts = [printer_name + online]
        printer_idx  = 0
    else:
        printer_opts = _CFG_PRINTER_FALLBACK
        printer_idx  = 0

    if _bambu:
        snap = _bambu.snapshot()
        if snap.filaments:
            fil_opts = [s.display() for s in snap.filaments]
            fil_idx  = 0
        else:
            fil_opts = _CFG_FILAMENT_FALLBACK
            fil_idx  = 0
    else:
        fil_opts = _CFG_FILAMENT_FALLBACK
        fil_idx  = 0

    return ([
        ("Printer",  printer_opts, printer_idx),
        ("Filament", fil_opts,     fil_idx),
    ] + _CFG_STATIC)


def build_print_config():
    return {name: idx for name, opts, idx in get_cfg_fields()}


# --- 3D renderer (unchanged) -----------------------------------------------

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


# --- Pygame init and theme -------------------------------------------------

pygame.font.init()
FONT_LG   = pygame.font.SysFont("segoeui", 32, bold=True)
FONT_MD   = pygame.font.SysFont("segoeui", 22)
FONT_SM   = pygame.font.SysFont("segoeui", 16)
FONT_MONO = pygame.font.SysFont("consolas", 18)

BG       = (13, 13, 20)
PANEL    = (22, 22, 38)
CARD     = (28, 28, 48)
CARD_SEL = (35, 55, 80)
ACCENT   = (0, 210, 160)
ACCENT2  = (0, 140, 255)
TEXT     = (220, 220, 230)
MUTED    = (110, 110, 130)
RED      = (220, 70, 70)
YELLOW   = (220, 180, 50)
GREEN    = (60, 200, 120)
DIM      = (45, 45, 65)


# --- Drawing helpers -------------------------------------------------------

def draw_rect(surf, color, rect, radius=8, border=0, border_color=None):
    pygame.draw.rect(surf, color, rect, border_radius=radius)
    if border and border_color:
        pygame.draw.rect(surf, border_color, rect, border, border_radius=radius)


def draw_text(surf, text, font, color, cx=None, x=None, y=0, right=None):
    surf2 = font.render(str(text), True, color)
    r = surf2.get_rect()
    if cx is not None:
        r.centerx = cx
    elif right is not None:
        r.right = right
    else:
        r.x = x or 0
    r.y = y
    surf.blit(surf2, r)
    return r


def numpy_frame_to_surface(frame):
    """Convert an HxWx3 BGR numpy array to a pygame Surface."""
    rgb = frame[:, :, ::-1]  # BGR -> RGB
    return pygame.surfarray.make_surface(np.transpose(rgb, (1, 0, 2)))


# --- Top bar ---------------------------------------------------------------

def draw_top_bar(surf, W, subtitle, status_msg):
    """Draw the 48px top bar."""
    BAR_H = 48
    draw_rect(surf, PANEL, (0, 0, W, BAR_H), radius=0)
    # Separator line
    pygame.draw.line(surf, DIM, (0, BAR_H - 1), (W, BAR_H - 1))

    # Left: DAVIS + subtitle
    draw_text(surf, "DAVIS", FONT_LG, ACCENT, x=14, y=8)
    davis_w = FONT_LG.size("DAVIS")[0]
    draw_text(surf, subtitle, FONT_SM, MUTED, x=14 + davis_w + 10, y=16)

    # Center: status
    if status_msg:
        draw_text(surf, status_msg, FONT_SM, MUTED, cx=W // 2, y=16)

    # Right: printer status
    dot_r = 6
    dot_x = W - 14
    name_x = dot_x - dot_r - 8

    if _bambu is not None:
        snap = _bambu.snapshot()
        if snap.online:
            dot_color  = GREEN
            label      = snap.printer_model
        else:
            dot_color  = YELLOW
            label      = "Connecting..."
    else:
        dot_color = MUTED
        label     = "No printer"

    draw_text(surf, label, FONT_SM, MUTED, right=name_x, y=16)
    pygame.draw.circle(surf, dot_color, (dot_x - dot_r, BAR_H // 2), dot_r)


# --- Input bar -------------------------------------------------------------

def draw_input_bar(surf, W, H, input_text, cursor_on, generating, btn_label=None):
    """Draw the 120px bottom input bar."""
    BAR_H    = 120
    bar_y    = H - BAR_H
    field_h  = 42

    draw_rect(surf, PANEL, (0, bar_y, W, BAR_H), radius=0)
    pygame.draw.line(surf, DIM, (0, bar_y), (W, bar_y))

    label_x = 14
    label_y = bar_y + (BAR_H - field_h) // 2
    draw_text(surf, "DESCRIBE:", FONT_SM, MUTED, x=label_x, y=label_y + 12)

    desc_w = FONT_SM.size("DESCRIBE:")[0]
    field_x = label_x + desc_w + 12
    btn_w   = 180
    field_w = W - field_x - btn_w - 28

    border_c = YELLOW if generating else ACCENT
    field_rect = (field_x, label_y, field_w, field_h)
    draw_rect(surf, CARD, field_rect, radius=6, border=2, border_color=border_c)

    display = input_text + ("|" if cursor_on else "")
    draw_text(surf, display, FONT_MONO, TEXT, x=field_x + 10, y=label_y + 12)

    if btn_label is None:
        btn_label = "GENERATING..." if generating else "ENTER = GENERATE"
    btn_col  = YELLOW if generating else ACCENT
    btn_rect = (W - btn_w - 14, label_y, btn_w, field_h)
    draw_rect(surf, CARD, btn_rect, radius=6, border=2, border_color=btn_col)
    draw_text(surf, btn_label, FONT_SM, btn_col,
              cx=W - btn_w - 14 + btn_w // 2, y=label_y + 13)


# --- Generate mode ---------------------------------------------------------

def draw_generate_mode(surf, W, H, model, input_text, cursor_on,
                       scale, rot_z, rot_x, status, status_color,
                       model_info, generating, tick):
    TOP_H = 48
    BOT_H = 120
    VP_H  = H - TOP_H - BOT_H
    VP_Y  = TOP_H

    surf.fill(BG)

    if model is None and not generating:
        # Idle screen
        cy = VP_Y + VP_H // 2
        draw_text(surf, "DAVIS  MODEL PREVIEW", FONT_LG, ACCENT, cx=W // 2, y=cy - 80)
        draw_text(surf, "Describe any object and press ENTER", FONT_MD, MUTED,
                  cx=W // 2, y=cy - 36)
        examples1 = "box   cylinder   hook   bracket   ring   stand"
        examples2 = "wedge   pyramid   sphere   cone   cross   hex"
        draw_text(surf, examples1, FONT_SM, (80, 160, 100), cx=W // 2, y=cy + 10)
        draw_text(surf, examples2, FONT_SM, (80, 160, 100), cx=W // 2, y=cy + 32)
        draw_text(surf, "Add dimensions:  box 6cm wide 3cm tall",
                  FONT_SM, MUTED, cx=W // 2, y=cy + 62)
        draw_text(surf, "Or try gallery:  show me vase models",
                  FONT_SM, (80, 180, 100), cx=W // 2, y=cy + 84)
    elif model is not None and not generating:
        # Render 3D model into viewport
        frame = render_frame(model, W, VP_H, scale, rot_z, rot_x)
        model_surf = numpy_frame_to_surface(frame)
        surf.blit(model_surf, (0, VP_Y))

        # Model info overlay (bottom-left of viewport)
        if model_info:
            oi_y = VP_Y + VP_H - 52
            info_rect = (6, oi_y, 420, 48)
            info_bg = pygame.Surface((420, 48), pygame.SRCALPHA)
            info_bg.fill((10, 10, 15, 180))
            surf.blit(info_bg, (6, oi_y))
            draw_text(surf, f"Scale {scale*100:.0f}%   Z {rot_z%360:.0f}deg   X {rot_x%360:.0f}deg",
                      FONT_SM, ACCENT, x=10, y=oi_y + 4)
            draw_text(surf, model_info, FONT_SM, MUTED, x=10, y=oi_y + 24)

        # Hint overlay (bottom-right of viewport)
        hints = ["Drag  Rotate", "Scroll  Scale", "<- ->  Rotate  Up Dn  Tilt", "=/-  Scale  R  Reset"]
        for i, h in enumerate(hints):
            draw_text(surf, h, FONT_SM, MUTED, right=W - 8, y=VP_Y + VP_H - 80 + i * 18)

    # Spinner overlay when generating
    if generating:
        overlay = pygame.Surface((W, VP_H), pygame.SRCALPHA)
        overlay.fill((0, 0, 0, 160))
        surf.blit(overlay, (0, VP_Y))
        dots = "." * (tick % 4 + 1)
        msg  = f'Generating "{input_text}"{dots}'
        draw_text(surf, msg, FONT_LG, ACCENT, cx=W // 2, y=VP_Y + VP_H // 2 - 24)
        draw_text(surf, "trimesh  ->  STL", FONT_SM, MUTED,
                  cx=W // 2, y=VP_Y + VP_H // 2 + 16)

    draw_top_bar(surf, W, "PREVIEW TEST", status)
    draw_input_bar(surf, W, H, input_text, cursor_on, generating)


# --- Gallery mode ----------------------------------------------------------

def draw_gallery_mode(surf, W, H, results, idx, loading, query, tick,
                      input_text, cursor_on):
    TOP_H = 48
    BOT_H = 120
    CONTENT_TOP = TOP_H + 8
    CONTENT_BOT = H - BOT_H - 8

    surf.fill(BG)

    if loading:
        status_msg = f'Searching for "{query}"...'
    elif results:
        status_msg = f'{len(results)} results for "{query}"'
    else:
        status_msg = f'No results for "{query}"'

    btn = "ENTER = SEARCH" if input_text.strip() else "ENTER = SELECT"
    draw_top_bar(surf, W, "GALLERY", status_msg)
    draw_input_bar(surf, W, H, input_text, cursor_on, False, btn)

    CY = (CONTENT_TOP + CONTENT_BOT) // 2

    if loading:
        dots = "." * (tick % 4 + 1)
        draw_text(surf, f"Searching{dots}", FONT_LG, ACCENT, cx=W // 2, y=CY - 20)
        return

    if not results:
        draw_text(surf, "No results found", FONT_LG, MUTED, cx=W // 2, y=CY - 24)
        draw_text(surf, "Try a different search term", FONT_MD, MUTED,
                  cx=W // 2, y=CY + 20)
        return

    avail_h = CONTENT_BOT - CONTENT_TOP
    CARD_W_MAIN = min(380, W // 3)
    CARD_H_MAIN = int(CARD_W_MAIN * 0.75)
    CARD_W_SIDE = int(CARD_W_MAIN * 0.55)
    CARD_H_SIDE = int(CARD_W_SIDE * 0.75)
    GAP = 24

    main_cx  = W // 2
    left_cx  = main_cx - CARD_W_MAIN // 2 - CARD_W_SIDE // 2 - GAP
    right_cx = main_cx + CARD_W_MAIN // 2 + CARD_W_SIDE // 2 + GAP

    def draw_card_pg(result, cx, cy_card, cw, ch, dimmed):
        x0 = cx - cw // 2
        y0 = cy_card - ch // 2
        if x0 < 0 or x0 + cw > W or y0 < 0 or y0 + ch > H:
            return

        # Card background
        draw_rect(surf, CARD, (x0, y0, cw, ch), radius=8)

        # Thumbnail
        thumb_h_area = ch - 32
        thumb = load_thumbnail(result, cw, thumb_h_area)
        if thumb is not None:
            th = min(thumb.shape[0], thumb_h_area)
            tw = min(thumb.shape[1], cw)
            thumb_surf = numpy_frame_to_surface(thumb[:th, :tw])
            # Clip to card area
            clip_rect = surf.get_clip()
            surf.set_clip((x0, y0, cw, ch - 32))
            surf.blit(thumb_surf, (cx - tw // 2, y0))
            surf.set_clip(clip_rect)

        # Dimming overlay
        if dimmed:
            dim_overlay = pygame.Surface((cw, ch), pygame.SRCALPHA)
            dim_overlay.fill((0, 0, 0, 140))
            surf.blit(dim_overlay, (x0, y0))

        # Name strip with gradient feel
        strip_y = y0 + ch - 32
        draw_rect(surf, (18, 18, 28), (x0, strip_y, cw, 32), radius=0)
        name = result.name[:30]
        nc = TEXT if not dimmed else MUTED
        draw_text(surf, name, FONT_SM, nc, cx=cx, y=strip_y + 8)

        # Border
        bc    = ACCENT if not dimmed else DIM
        thick = 2 if not dimmed else 1
        pygame.draw.rect(surf, bc, (x0, y0, cw, ch), thick, border_radius=8)

    if idx > 0:
        draw_card_pg(results[idx - 1], left_cx, CY, CARD_W_SIDE, CARD_H_SIDE, True)
    if idx < len(results) - 1:
        draw_card_pg(results[idx + 1], right_cx, CY, CARD_W_SIDE, CARD_H_SIDE, True)
    draw_card_pg(results[idx], main_cx, CY, CARD_W_MAIN, CARD_H_MAIN, False)

    r = results[idx]
    info_y = CY + CARD_H_MAIN // 2 + 16
    draw_text(surf, r.name, FONT_MD, TEXT, cx=main_cx, y=info_y)
    draw_text(surf, f"by {r.creator}   {r.likes} likes",
              FONT_SM, MUTED, cx=main_cx, y=info_y + 28)

    # Pagination dots
    dots_y   = info_y + 54
    n        = min(len(results), 20)
    dot_gap  = 14
    dx_start = W // 2 - n * dot_gap // 2
    for di in range(n):
        col  = ACCENT if di == idx else DIM
        size = 5 if di == idx else 3
        pygame.draw.circle(surf, col, (dx_start + di * dot_gap, dots_y), size)

    # Nav hint
    hint_y = H - BOT_H - 28
    draw_text(surf, "<-  Previous       ENTER = Select       Next  ->",
              FONT_SM, MUTED, cx=W // 2, y=hint_y)


# --- Print config mode -----------------------------------------------------

def draw_print_cfg_mode(surf, W, H, result, cfg, field_idx, confirming,
                         status, status_color):
    TOP_H    = 48
    BOT_H    = 58
    LEFT_W   = W // 2 - 20
    CONTENT_TOP = TOP_H + 10

    surf.fill(BG)
    draw_top_bar(surf, W, "PRINT CONFIG", status)

    # Thumbnail (left half)
    thumb_h = min(220, H - TOP_H - BOT_H - 120)
    thumb_w = min(LEFT_W - 20, int(thumb_h * 1.33))
    thumb = load_thumbnail(result, thumb_w, thumb_h)
    if thumb is not None:
        tx = 10 + (LEFT_W - thumb_w) // 2
        ty = CONTENT_TOP + 10
        th = min(thumb.shape[0], thumb_h)
        tw = min(thumb.shape[1], thumb_w)
        thumb_surf = numpy_frame_to_surface(thumb[:th, :tw])
        draw_rect(surf, CARD, (tx - 4, ty - 4, tw + 8, th + 8), radius=8)
        surf.blit(thumb_surf, (tx, ty))

    # Model info below thumbnail
    info_y = CONTENT_TOP + 10 + thumb_h + 16
    draw_text(surf, result.name[:32], FONT_MD, TEXT, cx=LEFT_W // 2 + 10, y=info_y)
    draw_text(surf, f"by {result.creator}", FONT_SM, MUTED,
              cx=LEFT_W // 2 + 10, y=info_y + 28)
    draw_text(surf, f"{result.likes} likes", FONT_SM, MUTED,
              cx=LEFT_W // 2 + 10, y=info_y + 48)
    draw_text(surf, f"thing:{result.thing_id}", FONT_SM, (80, 160, 100),
              cx=LEFT_W // 2 + 10, y=info_y + 68)

    # Divider
    pygame.draw.line(surf, DIM, (W // 2, TOP_H + 4), (W // 2, H - BOT_H - 4))

    # Form fields (right half)
    fields  = get_cfg_fields()
    FX      = W // 2 + 20
    FY      = CONTENT_TOP + 20
    F_ROW_H = max(36, (H - TOP_H - BOT_H - 40) // len(fields))
    ROW_W   = W - FX - 14

    for fi, (name, opts, default_idx) in enumerate(fields):
        val_idx = cfg.get(name, default_idx)
        val     = opts[val_idx]
        ry      = FY + fi * F_ROW_H
        active  = fi == field_idx

        bg_col  = CARD_SEL if active else CARD
        bdr_col = ACCENT   if active else None
        bdr_w   = 2        if active else 0
        draw_rect(surf, bg_col, (FX - 4, ry, ROW_W, F_ROW_H - 4),
                  radius=6, border=bdr_w, border_color=bdr_col)

        lbl_col = ACCENT if active else MUTED
        draw_text(surf, name, FONT_SM, lbl_col, x=FX + 8, y=ry + (F_ROW_H - 4) // 2 - 8)

        if active:
            arrow_col = YELLOW
            draw_text(surf, "<", FONT_MD, arrow_col,
                      x=FX + ROW_W // 2 - 10, y=ry + (F_ROW_H - 4) // 2 - 12)
            draw_text(surf, val, FONT_MD, TEXT,
                      cx=FX + ROW_W // 2 + 30, y=ry + (F_ROW_H - 4) // 2 - 12)
            val_w = FONT_MD.size(val)[0]
            draw_text(surf, ">", FONT_MD, arrow_col,
                      x=FX + ROW_W // 2 + 30 + val_w // 2 + 8,
                      y=ry + (F_ROW_H - 4) // 2 - 12)
        else:
            draw_text(surf, val, FONT_SM, TEXT,
                      right=FX + ROW_W - 12, y=ry + (F_ROW_H - 4) // 2 - 8)

    # Bottom hint bar
    bar_y = H - BOT_H
    draw_rect(surf, PANEL, (0, bar_y, W, BOT_H), radius=0)
    pygame.draw.line(surf, DIM, (0, bar_y), (W, bar_y))
    if confirming:
        draw_text(surf, "Sending to printer...", FONT_MD, YELLOW,
                  cx=W // 2, y=bar_y + 16)
    else:
        hint = "UP/DOWN  Move field    LEFT/RIGHT  Change value    ENTER  Print    ESC  Back"
        draw_text(surf, hint, FONT_SM, MUTED, cx=W // 2, y=bar_y + 20)


# --- Setup screen ----------------------------------------------------------

def draw_setup_mode(surf, W, H, discovered, access_input, cursor_on,
                    status, status_color, discovering):
    surf.fill(BG)
    draw_top_bar(surf, W, "PRINTER SETUP", status)

    CY  = H // 2
    CX  = W // 2
    CARD_W = min(600, W - 80)
    CARD_H = 260

    cx0 = CX - CARD_W // 2
    cy0 = CY - CARD_H // 2
    draw_rect(surf, PANEL, (cx0, cy0, CARD_W, CARD_H), radius=14,
              border=1, border_color=DIM)

    if discovering:
        n_dots = int(time.time() * 2) % 4 + 1
        dots   = "." * n_dots
        draw_text(surf, f"Scanning for Bambu printers{dots}",
                  FONT_MD, ACCENT, cx=CX, y=cy0 + 60)
        draw_text(surf, "Make sure printer is on the same Wi-Fi",
                  FONT_SM, MUTED, cx=CX, y=cy0 + 100)
        # Animated dots indicator
        for i in range(3):
            alpha = 255 if i < n_dots else 80
            c = tuple(int(v * alpha / 255) for v in ACCENT)
            pygame.draw.circle(surf, c,
                               (CX - 20 + i * 20, cy0 + 150), 7)
        return

    if not discovered:
        draw_text(surf, "No Bambu printer found on network",
                  FONT_MD, RED, cx=CX, y=cy0 + 60)
        draw_text(surf, "Make sure printer is on the same Wi-Fi",
                  FONT_SM, MUTED, cx=CX, y=cy0 + 96)
        draw_text(surf, "ESC to continue without printer",
                  FONT_SM, MUTED, cx=CX, y=cy0 + 130)
        return

    d = discovered[0]
    has_code = bool(d.get("access_code"))

    draw_text(surf, f"Found: {d['model']}", FONT_LG, ACCENT, cx=CX, y=cy0 + 30)
    draw_text(surf, f"{d['ip']}   {d['serial']}", FONT_SM, MUTED, cx=CX, y=cy0 + 70)

    if has_code:
        draw_text(surf, "Connecting...", FONT_MD, YELLOW, cx=CX, y=cy0 + 110)
    else:
        draw_text(surf, "Enter Access Code from printer touchscreen:",
                  FONT_SM, TEXT, cx=CX, y=cy0 + 106)
        draw_text(surf, "(Settings > Network > Access Code)",
                  FONT_SM, MUTED, cx=CX, y=cy0 + 128)
        box_w = 260
        bx = CX - box_w // 2
        by = cy0 + 152
        draw_rect(surf, CARD, (bx, by, box_w, 44), radius=6,
                  border=2, border_color=ACCENT)
        display = access_input + ("|" if cursor_on else "")
        draw_text(surf, display, FONT_MONO, TEXT, cx=CX, y=by + 12)
        draw_text(surf, "ENTER to connect    ESC to skip",
                  FONT_SM, MUTED, cx=CX, y=cy0 + 212)


# --- STL save --------------------------------------------------------------

def save_stl(mesh_trimesh, description):
    out_dir = os.path.join(os.path.dirname(__file__), "generation", "stl_cache")
    os.makedirs(out_dir, exist_ok=True)
    slug = description[:20].replace(" ", "_").replace("/", "-")
    path = os.path.join(out_dir, f"model_{slug}_{int(time.time())}.stl")
    mesh_trimesh.export(path)
    return path


# --- Main ------------------------------------------------------------------

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
    status_color = MUTED
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
    cfg_status_col = MUTED

    # Timer to auto-return from print confirm
    return_to_gallery_at = None
    # Cooldown: ignore ENTER for 0.3s after a mode switch (absorbs buffered keypresses)
    mode_changed_at = 0.0

    # Setup state
    setup_discovered   = []
    setup_discovering  = False
    setup_access_input = ""
    setup_status       = ""
    setup_status_col   = MUTED

    # Auto-discovery on startup if printer not configured
    global _bambu, _discovered_printers
    if not _printer_cfg:
        setup_discovering = True
        mode = AppMode.SETUP

        def _on_discovered(results):
            global _bambu, _discovered_printers
            nonlocal setup_discovered, setup_discovering, mode
            nonlocal setup_status, setup_status_col
            setup_discovered   = results
            setup_discovering  = False
            _discovered_printers = results

            complete = [r for r in results if r.get("access_code") and r.get("ip")]
            if complete:
                d = complete[0]
                save_config(d["ip"], d["serial"], d["access_code"], d["model"])
                apply_to_config(d)
                setup_status     = f"Auto-connected: {d['model']} at {d['ip']}"
                setup_status_col = GREEN
                mode = AppMode.GENERATE

        start_discovery(_on_discovered, ssdp_timeout=6.0)

    # -- Helper: start generate --------------------------------------------
    def start_gen(text):
        nonlocal generating, gen_result, status, status_color
        if not text.strip() or generating:
            return
        intent = parse_description(text)
        if intent is None:
            status       = f'Unknown shape: "{text[:40]}"  try: box, hook, bracket...'
            status_color = RED
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

    # -- Helper: gallery search --------------------------------------------
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
        nonlocal mode, mode_changed_at
        mode = AppMode.GALLERY
        mode_changed_at = time.time()
        start_gallery_search(query)

    # -- Helper: select gallery item -> print config -----------------------
    def select_gallery_item():
        nonlocal mode, cfg_result, cfg_values, cfg_field_idx
        nonlocal cfg_confirming, cfg_status, cfg_status_col, mode_changed_at
        if not gallery_results:
            return
        r = gallery_results[gallery_idx]
        cfg_result     = r
        cfg_values     = build_print_config()
        cfg_field_idx  = 0
        cfg_confirming = False
        cfg_status     = f"Configure: {r.name[:36]}"
        cfg_status_col = MUTED
        mode = AppMode.PRINT_CFG
        mode_changed_at = time.time()
        start_stl_download(r, token=_TOKEN)

    # -- Helper: confirm print ---------------------------------------------
    def do_print():
        nonlocal cfg_confirming, cfg_status, cfg_status_col, return_to_gallery_at
        if cfg_result is None:
            return
        cfg_confirming = True
        cfg_status     = "Preparing print job..."
        cfg_status_col = YELLOW

        summary = {name: opts[cfg_values.get(name, idx)]
                   for name, opts, idx in get_cfg_fields()}
        print(f"\n[PRINT JOB]  {cfg_result.name}")
        print(f"  URL: {cfg_result.thing_url}")
        for k, v in summary.items():
            print(f"  {k}: {v}")

        def _dispatch():
            nonlocal cfg_status, cfg_status_col, return_to_gallery_at

            t0 = time.time()
            while cfg_result.stl_downloading and time.time() - t0 < 30:
                time.sleep(0.3)

            if cfg_result.stl_error:
                cfg_status     = f"STL download failed: {cfg_result.stl_error[:50]}"
                cfg_status_col = RED
                return_to_gallery_at = time.time() + 3.0
                return

            stl_path = cfg_result.stl_path
            print(f"  STL: {stl_path}")

            try:
                import config as cfg_mod
                has_printer = (
                    cfg_mod.BAMBU_IP not in ("", "192.168.1.100") and
                    "XXX" not in cfg_mod.BAMBU_SERIAL and
                    cfg_mod.BAMBU_ACCESS_CODE not in ("", "XXXXXXXX")
                )
            except Exception:
                has_printer = False

            if not has_printer:
                cfg_status     = "Saved locally -- configure printer to dispatch"
                cfg_status_col = YELLOW
                return_to_gallery_at = time.time() + 3.0
                return

            try:
                from printer.ftps_transfer import upload_stl
                from printer.mqtt_client import send_print_job

                cfg_status     = "Slicing model..."
                cfg_status_col = YELLOW

                # Extract print settings from UI selection
                _fields = get_cfg_fields()
                _summary = {name: opts[cfg_values.get(name, idx)]
                            for name, opts, idx in _fields}
                _printer_model = _summary.get("Printer", "Bambu A1").split("  ")[0]
                _layer_h       = _summary.get("Layer Height", "0.20mm")
                _filament      = _summary.get("Filament", "PLA")

                remote_name = upload_stl(stl_path,
                                         printer_model=_printer_model,
                                         layer_height=_layer_h,
                                         filament=_filament)
                cfg_status     = "Sending print command..."
                cfg_status_col = YELLOW
                send_print_job(remote_name, bambu_status=_bambu)

                cfg_status     = f"Printing: {cfg_result.name[:40]}"
                cfg_status_col = GREEN
                print(f"  [OK] Dispatched to printer")
            except Exception as exc:
                cfg_status     = f"Printer error: {str(exc)[:60]}"
                cfg_status_col = RED
                print(f"  [ERROR] {exc}")

            return_to_gallery_at = time.time() + 3.0

        threading.Thread(target=_dispatch, daemon=True).start()

    # -- Main loop ---------------------------------------------------------
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
                status_color = RED
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
                status_color = GREEN
                print(f"\nSTL: {stl_path}\n     {model_info}")

        # Events
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                return

            elif event.type == pygame.KEYDOWN:
                k = event.key
                enter_ready = (k != pygame.K_RETURN or
                               time.time() - mode_changed_at > 0.3)

                # ESC always goes back one level
                if k == pygame.K_ESCAPE:
                    mode_changed_at = time.time()
                    if mode == AppMode.SETUP:
                        mode = AppMode.GENERATE
                    elif mode == AppMode.PRINT_CFG:
                        mode = AppMode.GALLERY
                    elif mode == AppMode.GALLERY:
                        mode = AppMode.GENERATE
                    else:
                        pygame.quit()
                        return

                # SETUP mode keys
                elif mode == AppMode.SETUP:
                    if not setup_discovering and setup_discovered:
                        if k == pygame.K_RETURN and enter_ready and setup_access_input.strip():
                            d = setup_discovered[0]
                            save_config(d["ip"], d["serial"],
                                        setup_access_input.strip(), d["model"])
                            apply_to_config({
                                "ip": d["ip"], "serial": d["serial"],
                                "access_code": setup_access_input.strip(),
                                "model": d["model"],
                            })
                            _bambu = get_bambu_status()
                            setup_status     = f"Connected: {d['model']}"
                            setup_status_col = GREEN
                            mode_changed_at  = time.time()
                            mode = AppMode.GENERATE
                        elif k == pygame.K_BACKSPACE:
                            setup_access_input = setup_access_input[:-1]
                        else:
                            ch = event.unicode
                            if ch and ch.isprintable() and len(setup_access_input) < 12:
                                setup_access_input += ch

                # GENERATE mode keys
                elif mode == AppMode.GENERATE:
                    if k == pygame.K_RETURN and enter_ready:
                        q = is_gallery_intent(input_text)
                        if q is not None:
                            enter_gallery(q)
                            input_text = ""   # clear so ENTER in gallery selects, not re-searches
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
                    if k == pygame.K_RETURN and enter_ready:
                        if input_text.strip():
                            q = is_gallery_intent(input_text) or input_text.strip()
                            start_gallery_search(q)
                            input_text = ""
                        else:
                            if gallery_loading:
                                status = "Still loading..."
                            elif gallery_results:
                                select_gallery_item()
                    elif k == pygame.K_LEFT:
                        gallery_idx = max(0, gallery_idx - 1)
                    elif k == pygame.K_RIGHT:
                        if gallery_results:
                            gallery_idx = min(len(gallery_results) - 1, gallery_idx + 1)
                    elif k == pygame.K_BACKSPACE:
                        input_text = input_text[:-1]
                    else:
                        ch = event.unicode
                        if ch and ch.isprintable() and len(input_text) < 60:
                            input_text += ch

                # PRINT CONFIG mode keys
                elif mode == AppMode.PRINT_CFG:
                    _fields = get_cfg_fields()
                    if k == pygame.K_RETURN and not cfg_confirming and enter_ready:
                        do_print()
                    elif k == pygame.K_UP:
                        cfg_field_idx = (cfg_field_idx - 1) % len(_fields)
                    elif k == pygame.K_DOWN:
                        cfg_field_idx = (cfg_field_idx + 1) % len(_fields)
                    elif k == pygame.K_LEFT:
                        name, opts, default_idx = _fields[cfg_field_idx]
                        cur = cfg_values.get(name, default_idx)
                        cfg_values[name] = (cur - 1) % len(opts)
                        # If Printer field changed, apply to config
                        if name == "Printer" and _discovered_printers:
                            new_idx = cfg_values[name]
                            if new_idx < len(_discovered_printers):
                                apply_to_config(_discovered_printers[new_idx])
                    elif k == pygame.K_RIGHT:
                        name, opts, default_idx = _fields[cfg_field_idx]
                        cur = cfg_values.get(name, default_idx)
                        cfg_values[name] = (cur + 1) % len(opts)
                        # If Printer field changed, apply to config
                        if name == "Printer" and _discovered_printers:
                            new_idx = cfg_values[name]
                            if new_idx < len(_discovered_printers):
                                apply_to_config(_discovered_printers[new_idx])

            # Mouse events
            elif event.type == pygame.MOUSEBUTTONDOWN and event.button == 1:
                dragging  = True
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

        # -- Render --------------------------------------------------------
        cursor_on = (cursor_tick // 30) % 2 == 0

        if mode == AppMode.GENERATE:
            draw_generate_mode(screen, W, H, model, input_text, cursor_on,
                               scale, rot_z, rot_x, status, status_color,
                               model_info, generating, tick)

        elif mode == AppMode.GALLERY:
            draw_gallery_mode(screen, W, H, gallery_results, gallery_idx,
                              gallery_loading, gallery_query, tick,
                              input_text, cursor_on)

        elif mode == AppMode.PRINT_CFG:
            if cfg_result is not None:
                draw_print_cfg_mode(screen, W, H, cfg_result, cfg_values,
                                    cfg_field_idx, cfg_confirming,
                                    cfg_status, cfg_status_col)

        elif mode == AppMode.SETUP:
            draw_setup_mode(screen, W, H, setup_discovered, setup_access_input,
                            cursor_on, setup_status, setup_status_col,
                            setup_discovering)

        pygame.display.flip()
        clock.tick(60)
        tick        += 1
        cursor_tick += 1


if __name__ == "__main__":
    main()
