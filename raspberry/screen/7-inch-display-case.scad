/*
 * (c) 2018 Sergio Visinoni - piffio
 *
 * Licensed under CC Attribution - ShareAlike 3.0
 * https://creativecommons.org/licenses/by-sa/3.0/
 *
 * 7 inches display case
 *
 */

/* Dimensions */
// Display
// See https://images-na.ssl-images-amazon.com/images/I/61ueLY60kFL._SL1030_.jpg for reference

$fn=100;

tol = 0.5; // general tolerance
ext_width = 0.4;
wall = ext_width * 2;
front_case_h = 13.0;
back_case_h = 4.0;
front_case_h_tot = front_case_h+2*wall+2*tol;
back_case_h_tot = back_case_h+2*wall+2*tol;

display_pcb = [164, 124, 1.5];
display_screen = [164, 99.3, 7.5];
display_screen_offset = [7.4, 3.5, 3.0, 6.3];
bottom_display_pcb_offset = 5.4;

hdmi_w=16.5;
hdmi_h=8;
hdmi_y_offset=10.5;
hdmi_z_offset=8.5;
hdmi_z_offset_back=back_case_h_tot - (hdmi_h + hdmi_z_offset - front_case_h_tot) - tol;

usb_w=9.5;
usb_h=7.5;
usb_y_offset=hdmi_y_offset + hdmi_w + 5;
usb_z_offset=hdmi_z_offset - 1.0;

screw_support_int_r = 1.4;
screw_support_int_h = display_screen[2] + display_pcb[2] + 2 + tol;
screw_support_ext_r = 3.5;
screw_support_ext_h = display_screen[2];

back_screw_support_ext_h = back_case_h_tot + (front_case_h_tot - screw_support_int_h + 2);

true_screen_x = display_screen[0] - display_screen_offset[1] - display_screen_offset[3];
true_screen_y = display_screen[1] - display_screen_offset[0] - display_screen_offset[2];

hth_x = 156.9; // Distance from the screw holes centers on the x axis
hth_y = 114.96; // Distance from the screw holes centers on the y axis

// Case
corner_r = wall; // casing corner radius
front_case_out = [display_pcb[0] + 2*wall + 2*tol, display_pcb[1] + 2*wall+2*tol, front_case_h_tot];
back_case_out = [front_case_out[0], front_case_out[1], back_case_h_tot];

module front_cover() {
	hole_x = 2*tol + front_case_out[0] - wall;
	hole_y = 2*tol + front_case_out[1] - wall;
	hole_z = 2*tol + front_case_out[2] - wall;

	border_x = hole_x + wall + tol;
	border_y = hole_y + wall + tol;
	border_z = 2 + tol;

	difference() {
		hull () for (x = [-1, 1]) for (y = [-1, 1])
			translate([x*(front_case_out[0]/2+tol+wall-corner_r), y*(front_case_out[1]/2+tol+wall-corner_r) , corner_r])
			{
				sphere(r = corner_r, $fs=0.3);
				cylinder(r = corner_r, h = front_case_out[2]-corner_r, $fs=0.3);
			}
		translate([-(hole_x/2), -(hole_y/2), wall])
			cube([hole_x, hole_y, hole_z]);
		translate([-(border_x/2), -(border_y/2), front_case_h_tot- border_z])
			cube([border_x, border_y, 2*tol + 5]);
		front_hdmi_plug();
		usb_plug();
	}
	front_screw_supports();
}

module test_snap() {
	base_x = 6;
	base_y = 2;
	base_z = 6;
	prism_l = base_x;
	prism_w = 1.2;
	prism_h = 1.2;

	snap(base_x, base_y, base_z, prism_l, prism_w, prism_h);
}

module snaps() {
	base_x = 6;
	base_y = 2;
	base_z = front_case_out[2] + 2 + wall;
	prism_l = base_x;
	prism_w = wall;
	prism_h = 1.2;

	hole_x = 2*tol + front_case_out[0] - wall;
	hole_y = 2*tol + front_case_out[1] - wall;

	translate([(hole_x/3 - base_x)/2, hole_y/2-base_y, 0])
		snap(base_x, base_y, base_z, prism_l, prism_w, prism_h);
	translate([(-hole_x/3 - base_x)/2, hole_y/2-base_y, 0])
		snap(base_x, base_y, base_z, prism_l, prism_w, prism_h);
	translate([(hole_x/3 + base_x)/2, -hole_y/2+base_y, 0])
		rotate([0,0,180])
			snap(base_x, base_y, base_z, prism_l, prism_w, prism_h);
	translate([(-hole_x/3 + base_x)/2, -hole_y/2+base_y, 0])
		rotate([0,0,180])
			snap(base_x, base_y, base_z, prism_l, prism_w, prism_h);
}

module snap(base_x, base_y, base_z, prism_l, prism_w, prism_h) {
	cube([base_x, base_y, base_z]);

	translate([base_x, base_y + prism_w, base_z - prism_h])
		rotate([0,0,180])
			prism(prism_l, prism_w, prism_h);

	translate([0, base_y + prism_w, base_z - prism_h])
		rotate([180,0,0])
			prism(prism_l, prism_w, prism_h);
}

module snap_holes() {
	prism_l = 6 + 2*tol;
	prism_w = wall + 2*tol;
	prism_h = 1.2 + 2*tol;
	hole_x = 2*tol + back_case_out[0] - wall;
	hole_y = 2*tol + back_case_out[1] - wall;
	hole_z_offset = back_case_out[2] - 2;

	translate([(hole_x/3 - prism_l)/2, (hole_y/2 + prism_w - tol), hole_z_offset])
		snap_hole(prism_l, prism_w, prism_h);
	translate([(-hole_x/3 - prism_l)/2, (hole_y/2 + prism_w - tol), hole_z_offset])
		snap_hole(prism_l, prism_w, prism_h);
	translate([(hole_x/3 + prism_l)/2, (-hole_y/2 - prism_w + tol), hole_z_offset])
		rotate([0,0,180])
			snap_hole(prism_l, prism_w, prism_h);
	translate([(-hole_x/3 + prism_l)/2, (-hole_y/2 - prism_w + tol), hole_z_offset])
		rotate([0,0,180])
			snap_hole(prism_l, prism_w, prism_h);

}

module snap_hole(prism_l, prism_w, prism_h) {
	translate([prism_l, 0,0])
		rotate([0,0,180])
			prism(prism_l, prism_w, prism_h);

	rotate([180,0,0])
		prism(prism_l, prism_w, prism_h);
}

module prism(l, w, h){
	polyhedron(
		points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
		faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
	);
}


module back_cover() {
	hole_x = 2*tol + back_case_out[0] - wall;
	hole_y = 2*tol + back_case_out[1] - wall;
	hole_z = 2*tol + back_case_out[2] - wall;

	border_x = hole_x + wall + tol;
	border_y = hole_y + wall + tol;
	border_z = 2 + tol;

	difference() {
		back_cover_external();
		translate([-(hole_x/2), -(hole_y/2), wall])
			cube([hole_x, hole_y, hole_z+border_z]);
		back_hdmi_plug();

		cube([back_case_out[0]-20, back_case_out[1] - 20, 2*tol + wall], center=true);
		snap_holes();
	}

	back_screw_supports();
}

module back_cover_external() {
	hole_x = 2*tol + back_case_out[0] - wall;
	hole_y = 2*tol + back_case_out[1] - wall;
	hole_z = 2*tol + back_case_out[2] - wall;

	border_x = hole_x + wall + tol;
	border_y = hole_y + wall + tol;
	border_z = back_case_out[2] + 2;

	hull () for (x = [-1, 1]) for (y = [-1, 1])
		translate([x*(back_case_out[0]/2+tol+wall-corner_r), y*(back_case_out[1]/2+tol+wall-corner_r) , corner_r])
		{
			sphere(r = corner_r, $fs=0.3);
			cylinder(r = corner_r, h = back_case_out[2]-corner_r, $fs=0.3);
		}

	translate([-(border_x/2), -(border_y/2), 0])
		cube([border_x, border_y, border_z]);
}



module front_hdmi_plug() {
	direction = -1;
	z_offset = hdmi_z_offset;

	translate([direction * (front_case_out[0])/2-tol-wall, (front_case_out[1])/2-2*tol-2*wall-hdmi_y_offset-hdmi_w, wall+z_offset])
		cube([wall+2*tol, hdmi_w, hdmi_h]);
}

module back_hdmi_plug() {
	direction = 1;
	z_offset = hdmi_z_offset_back;

	translate([direction * (front_case_out[0])/2 -tol, (front_case_out[1])/2-2*tol-2*wall-hdmi_y_offset-hdmi_w, wall+z_offset])
		cube([wall+2*tol, hdmi_w, hdmi_h]);
}

module usb_plug() {
	translate([-(front_case_out[0])/2-tol-wall, (front_case_out[1])/2-2*tol-2*wall-usb_y_offset-usb_w, wall+usb_z_offset])
	cube([wall+2*tol, usb_w, usb_h]);
}

module display_hole() {
	translate([-true_screen_x/2 - tol + display_screen_offset[3]/2, - true_screen_y/2 - tol + display_screen_offset[2]/2 + bottom_display_pcb_offset/2]) {
		cube([true_screen_x, true_screen_y, wall]);
	}
}

module front_screw_supports() {
	translate([-hth_x/2, hth_y/2])
		front_screw_support();

	translate([-hth_x/2, -hth_y/2])
		front_screw_support();

	translate([hth_x/2, hth_y/2])
		front_screw_support();

	translate([hth_x/2, -hth_y/2])
		front_screw_support();
}

module front_screw_support() {
	cylinder(r = screw_support_int_r, h = screw_support_int_h);
	cylinder(r = screw_support_ext_r, h = screw_support_ext_h);
}

module back_screw_supports() {
	translate([-hth_x/2, hth_y/2])
		back_screw_support();

	translate([-hth_x/2, -hth_y/2])
		back_screw_support();

	translate([hth_x/2, hth_y/2])
		back_screw_support();

	translate([hth_x/2, -hth_y/2])
		back_screw_support();
}

module back_screw_support() {
	difference() {
		cylinder(r = screw_support_ext_r, h = back_screw_support_ext_h);
		translate([0, 0, back_screw_support_ext_h - 3])
			cylinder(r = screw_support_int_r, h = screw_support_int_h/2);
	}
}

difference() {
	front_cover();
	display_hole();
}

translate([0, display_pcb[1]*1.2,0])
	back_cover();

snaps();

//!test_snap();
//!snap_hole(6 + 2*tol, wall + 2*tol, 1.2 + 2*tol);