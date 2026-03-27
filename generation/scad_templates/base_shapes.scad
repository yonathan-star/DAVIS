// DAVIS — Base shape library (imported by shape_gen templates)

// Chamfered box
module chamfer_box(w, h, d, c=1) {
    hull() {
        translate([c, c, 0])       cube([w-2*c, h-2*c, d]);
        translate([0, c, c])       cube([w,     h-2*c, d-2*c]);
        translate([c, 0, c])       cube([w-2*c, h,     d-2*c]);
    }
}

// L-bracket profile extruded along Z
module l_bracket(w, h, flange_w, flange_h, thickness, length) {
    linear_extrude(height=length) {
        square([thickness, h]);
        square([w, thickness]);
    }
}

// S-hook
module s_hook(r=8, wire_d=3, turns=0.75) {
    $fn = 48;
    rotate_extrude(angle=turns*360)
        translate([r, 0]) circle(d=wire_d);
    translate([0, 0, r])
    rotate([180,0,0])
    rotate_extrude(angle=turns*360)
        translate([r, 0]) circle(d=wire_d);
}
