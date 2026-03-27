// DAVIS — Parametric Label
// Parameters injected by text_gen.py via OpenSCAD -D flag

label_text  = "LABEL";    // text to emboss
width       = 60;         // mm
height      = 20;         // mm
depth       = 3;          // mm (base thickness)
text_depth  = 1.2;        // mm emboss depth
font_size   = 0;          // 0 = auto-fit
border      = 2;          // mm border around text
corner_r    = 2;          // corner radius

_font_size = font_size > 0 ? font_size : (height - border * 2) * 0.75;

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
}

// Embossed text
translate([width/2, height/2, depth])
    linear_extrude(height=text_depth)
        text(label_text,
             size=_font_size,
             font="Liberation Sans:style=Bold",
             halign="center",
             valign="center");
