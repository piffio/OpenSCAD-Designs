/*
 * (c) 2018 Sergio Visinoni - piffio
 *
 * Licensed under CC Attribution - ShareAlike 3.0
 * https://creativecommons.org/licenses/by-sa/3.0/
 *
 */
neckwidth=3;
pvcoutd=20;
pvcind=15;
basewidth=20;
corner_r = 2;
overlap=10;
necklen = overlap + corner_r;
tolerance=0.2;

$fn=100;

hull() {
rotate_extrude(angle = 360)
	translate([basewidth, 0, 0])
		circle(r = corner_r);
}

difference() {
	cylinder(d = pvcoutd + 2 * neckwidth, h = necklen);
	cylinder(d = pvcoutd + 2 * tolerance, h = necklen + tolerance);
}

cylinder(d = pvcind - 2 * tolerance, h = corner_r + 5);

translate([0, 0, necklen])
	rotate_extrude(angle = 360)
		translate([pvcoutd / 2 + (neckwidth + tolerance)/2, 0])
			circle(r = (neckwidth - tolerance) / 2);
