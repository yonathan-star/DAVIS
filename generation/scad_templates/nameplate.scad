// DAVIS — Parametric Nameplate with mounting holes

nameplate_text = "NAME";
width          = 80;
height         = 25;
depth          = 4;
text_depth     = 1.5;
font_size      = 0;
border         = 3;
corner_r       = 2;
hole_d         = 3.5;   // screw hole diameter
hole_margin    = 5;     // distance from edge to hole center

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
    // Mounting holes
    translate([hole_margin, height/2, -0.1])
        cylinder(d=hole_d, h=depth+0.2, $fn=24);
    translate([width-hole_margin, height/2, -0.1])
        cylinder(d=hole_d, h=depth+0.2, $fn=24);
}

// Embossed text
translate([width/2, height/2, depth])
    linear_extrude(height=text_depth)
        text(nameplate_text,
             size=_font_size,
             font="Liberation Sans:style=Bold",
             halign="center",
             valign="center");
