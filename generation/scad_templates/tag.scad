// DAVIS — Parametric Tag with lanyard hole

tag_text   = "TAG";
width      = 40;
height     = 55;
depth      = 2.5;
text_depth = 1.0;
font_size  = 0;
border     = 3;
corner_r   = 3;
hole_d     = 5;     // lanyard hole diameter
hole_y     = 7;     // distance from top edge to hole center

_font_size = font_size > 0 ? font_size : (width - border * 2) * 0.55;

module rounded_rect(w, h, d, r) {
    hull() {
        translate([ r,  r, 0]) cylinder(r=r, h=d, $fn=32);
        translate([w-r,  r, 0]) cylinder(r=r, h=d, $fn=32);
        translate([ r, h-r, 0]) cylinder(r=r, h=d, $fn=32);
        translate([w-r, h-r, 0]) cylinder(r=r, h=d, $fn=32);
    }
}

difference() {
    rounded_rect(width, height, depth, corner_r);
    // Lanyard hole at top
    translate([width/2, height - hole_y, -0.1])
        cylinder(d=hole_d, h=depth+0.2, $fn=32);
}

// Embossed text (centered vertically below hole area)
translate([width/2, (height - hole_y*2) / 2 + border, depth])
    linear_extrude(height=text_depth)
        text(tag_text,
             size=_font_size,
             font="Liberation Sans:style=Bold",
             halign="center",
             valign="center");
