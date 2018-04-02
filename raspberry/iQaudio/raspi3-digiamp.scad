/*
 * * * (c) 2018 Sergio Visinoni - piffio
 *
 * Licensed under CC Attribution - ShareAlike 3.0
 * https://creativecommons.org/licenses/by-sa/3.0/
 *
 * Raspberry Pi 3 with iQaudio Pi-Digiamp+.
 *
 * This case is designed specifically to hold a Raspberry Pi 3 with a Pi-Digiamp+ HAT
 * from iQaudio.
 *
 * The design has been lightly derived from the Raspberry Pi 3 case designed by guysoft.
 * The original copyright notice follows
 *
 * =======================================================================
 *
 * raspberry pi model B+
 *
 * design by Egil Kvaleberg, 8 Aug 2015
 * Rasoberrypi 3 adapt by Guy Sheffer 28 Apr 2016
 *
 * drawing of the B+ model, for referrence:
 * https://www.raspberrypi.org/documentation/hardware/raspberrypi/mechanical/Raspberry-Pi-B-Plus-V1.2-Mechanical-Drawing.pdf
 *
 * notes:
 * design origin is middle of PCB
 */

use <raspberrypi.scad>
use <iQaudio.scad>

// Variables
show_board = 0;

have_sdcard_support = 1; // [ 1:true, 0:false ]

// Constants

pcb = [85.0, 56.0, 1.5]; // main board
pcb2floor = 4.0;
pcb2roof = 30.0;

pcbmntdia = 3; // mounting holes
pcbmnt1dx = pcb[0]/2 - 3.5;  //
pcbmnt1dy = 3.5 - pcb[1]/2;
pcbmnt2dx = pcb[0]/2 - 3.5 - 58.0; //
pcbmnt2dy = pcb[1]/2 - 3.5;
pcbmnthead = 6.2; // countersunk
pcbmntheadthick = 4.2;
breakaway = 0; // have hidden hole for screw, 0 for no extra pegs
hatdz = 13.4;
hatsz = 1.4;

tol = 0.5; // general tolerance

cardsy = 12.0; // card measures 11.0
cardsz = 2;
cardsx = 8.0; // size of internal platform
carddy = pcb[1]/2 - 28.0;
powerpsx = 10.0; // power plug width
powerpsz = 4.5; // plug height
powerssx = 8.0; // power socket width
powerssz = 3.3; // socket height
powerdz = -1.0; // for plug
powerdx = pcb[0]/2 - 10.6; //
hdmisx = 15.2; // hdmi contact width
hdmisz = 6.2;
hdmipsx = 16.0; // typical plug
hdmipsz = 4;
hdmidx = pcb[0]/2 - 32.0;
audior = 6.8; // audio contact radius
audiodz = 6.0/2; // above pcb
audiodx = pcb[0]/2 -53.5;
ethery = 15.5;
etherz = 13;
etherdy = pcb[1]/2 - 10.8;
usbsy = 11; // core
usbframe = 1.0; // frame
usbsz = 14.5;
usb1dy = pcb[1]/2 - 29.0;
usb2dy = pcb[1]/2 - 47.0;

wall = 2.0; // general wall thickness

iq_powersx = 8.5;
iq_powersz = 10;
iq_powerdx = pcb[0]/2 - 12.3 - wall;
iq_powerdz = hatdz + hatsz;

iq_speakersx = 10;
iq_speakersz = 6;
iq_speakerrdx = pcb[0] / 2 - 28 - wall;
iq_speakerldx = iq_speakerrdx - 19;
iq_speakerdz = hatdz + hatsz;

frame_w = 2.5; // width of lip for frame
corner_r = wall; // casing corner radius
corner2_r = wall+tol+wall; // corners of top casing
d = 0.01;

extra_x = 2.0; // extra space in x
extra_y = 1.0; // extra space in y

if (show_board) {
	rotate(180) translate([0,0,wall+pcb2floor])
	{
		pi3();
		digiamp();
	}
}


module c_cube(x, y, z) {
	translate([-x/2, -y/2, 0]) cube([x, y, z]);
}

module snap_plug() {
	b = 1.13;
	h = 1.13;
	w = 5;

	rotate(a=[0,90,0])
		rotate(a=[0,0,45])
			linear_extrude(height = w, center = true, convexity = 10, twist = 0)
				polygon(points=[[0,0],[h,0],[0,b]], paths=[[0,1,2]]);

}

module snap() {
	for (y = [-1, 1])
		translate([0, y*(pcb[1]/2+wall/2) + (y < 0 ? -extra_y : 0), 0]) {
		  yrot = (y == 1 ? 180 : 0);
			rotate(a = [yrot, 0, 0])
				snap_plug();
		}
	for (x = [-1, 1])
		translate([x*(pcb[0]/2+wall/2) + (x<0 ? -extra_x : 0), 0, 0]) {
		  xrot = (x == -1 ? 180 : 0);
			rotate(a = [0, 0, 90+xrot])
				snap_plug();
		}
}

module bottom() {
	module snap_holes() {
		translate([0,0,wall+pcb2floor+pcb2roof+pcb[2]-1.6])
			snap();
	}

	module plugs(extra) {
		module usb_plug(dy) {
			translate([-pcb[0]/2, dy, z0-extra])
				c_cube(19.9, usbsy+2*extra, usbsz+2*extra);
			translate([-pcb[0]/2 -19.9/2, dy, z0-extra])
				c_cube(19.9, usbsy+2*usbframe+2*extra, usbsz+2*extra+2*usbframe/2);
		}

		z0 = wall+pcb2floor+pcb[2];

		// SD Card Slot
		translate([pcb[0]/2 - cardsx/4 + wall, carddy, -tol])
			c_cube(cardsx/2+wall, cardsy+2*extra, wall+pcb2floor+cardsz+2*extra);

		// Power Plug Hole
		translate([powerdx, pcb[1]/2+wall/2, z0+powerdz-extra])
			c_cube(powerpsx+2*extra, 3/5*wall, wall+pcb2roof);

		// HDMI Hole
		translate([hdmidx, pcb[1]/2+4.5, z0-extra])
			c_cube(hdmipsx+2*extra, 8.25, hdmipsz+2*extra+frame_w);
		translate([hdmidx, pcb[1]/2+wall/2, hdmipsz+2*extra+frame_w])
			c_cube(hdmipsx+2*extra, 3/5*wall, wall+pcb2roof);

		// Audio Jack
		translate([audiodx, pcb[1]/2 , z0+audiodz])
			rotate([-90, 0, 0]) cylinder(r=audior/2+tol, h=2* wall+2*d, $fn=20);
		translate([audiodx, pcb[1]/2+wall/2, z0+audiodz])
			c_cube(audior+2*extra, 3/5*wall, wall+pcb2roof);

		// Ethernet Plug
		translate([-(pcb[0]/2 + extra_x + wall/2), etherdy, z0-extra])
			c_cube(2*wall, ethery+2*extra, etherz+2*extra);

		usb_plug(usb1dy);
		usb_plug(usb2dy);
  }

	module iqaudio_plugs(extra) {
		z0 = wall+pcb2floor+pcb[2];

		// Power Plug Hole
		translate([iq_powerdx, pcb[1]/2, z0 + iq_powerdz-extra])
			c_cube(iq_powersx + 2*extra, 2*wall + 2*extra, iq_powersz);

		// Right speaker out
		translate([iq_speakerrdx, pcb[1]/2, z0 + iq_speakerdz-extra])
			c_cube(iq_speakersx + 2*extra, 2*wall + 2*extra, iq_speakersz);

		// Right speaker out
		translate([iq_speakerldx, pcb[1]/2, z0 + iq_speakerdz-extra])
			c_cube(iq_speakersx + 2*extra, 2*wall + 2*extra, iq_speakersz);
	}

  module plugs_add() {
      z0 = wall+pcb2floor+pcb[2];
      // card slot
      if (have_sdcard_support) difference () {
          translate([pcb[0]/2 + tol + d - cardsx/2, carddy, 0])
              c_cube(cardsx, cardsy+2*tol+2*wall, wall+frame_w-tol);
          plugs(tol);
      }
  }

	module add() {
		hull () for (x = [-1, 1]) for (y = [-1, 1])
			translate([x*(pcb[0]/2+tol+wall-corner_r) + (x<0 ? -extra_x : 0), y*(pcb[1]/2+tol+wall-corner_r) + (y<0 ? -extra_y : 0), corner_r]) {
				sphere(r = corner_r, $fs=0.3);
				cylinder(r = corner_r, h = wall+pcb2floor+pcb2roof+pcb[2]-corner_r, $fs=0.3);
			}
	}

	module sub() {
		module pedestal(dx, dy, hg, dia) {
			translate([dx, dy, wall]) {
				cylinder(r = dia/2+1.5*wall, h = hg, $fs=0.2);
				// pegs through pcb mount holes
				if (breakaway > 0) translate([0, 0, hg])
					cylinder(r = dia/2 - tol, h = pcb[2]+d, $fs=0.2);
			}
		}
		module pedestal_hole(dx, dy, hg, dia) {
			translate([dx, dy, breakaway]) {
				cylinder(r = dia/2, h = wall+hg-2*breakaway, $fs=0.2);
				cylinder(r = 1.0/2, h = wall+hg+pcb[2]+d, $fs=0.2); // needed to 'expose' internal structure so it does not get removed
				cylinder(r = pcbmnthead/2 - breakaway, h = pcbmntheadthick - breakaway, $fs=0.2); // countersunk head
			}
		}
		difference () {
			// pcb itself
			translate([-(pcb[0]/2+tol)-extra_x, -(pcb[1]/2+tol)-extra_y, wall])
				cube([2*tol+pcb[0]+extra_x, 2*tol+pcb[1]+extra_y, pcb2floor+pcb2roof+pcb[2]+d]);
			// less pcb mount pedestals
			for (dx = [pcbmnt1dx,pcbmnt2dx]) for (dy = [pcbmnt1dy,pcbmnt2dy])
				pedestal(dx, dy, pcb2floor, pcbmntdia);
		}
		// hole for countersunk pcb mounting screws, hidden (can be broken away)
		for (dx = [pcbmnt1dx,pcbmnt2dx]) for (dy = [pcbmnt1dy,pcbmnt2dy])
			pedestal_hole(dx, dy, pcb2floor, pcbmntdia);
		plugs(tol);
		iqaudio_plugs(tol);
		snap_holes();
	}

	difference() {
		add();
		sub();
	}
	plugs_add();
}

module lid() {
	difference() {
		hull () for (x = [-1, 1]) for (y = [-1, 1])
			translate([x*(pcb[0]/2+tol+wall-corner_r) + (x<0 ? -extra_x : 0), y*(pcb[1]/2+tol+wall-corner_r) + (y < 0 ? -extra_y : 0), corner_r])
				sphere(r = corner_r, $fs=0.3);
		translate([-(pcb[0]), -(pcb[1]), wall])
			cube([2*pcb[0], 2*pcb[1], pcb2floor+pcb[2]+d]);
	}
	difference() {
		translate([-(pcb[0]/2)-extra_x, -(pcb[1]/2)-extra_y, wall])
			cube([pcb[0]+extra_x, pcb[1]+extra_y, 3]);
		translate([-(pcb[0]/2+tol-wall)-extra_x, -(pcb[1]/2+tol-wall)-extra_y, wall])
			cube([2*tol+pcb[0]+extra_x-2*wall, 2*tol+pcb[1]+extra_y-2*wall, 3+d]);
	}

	translate([0,0,wall+1.8])
		snap();
}

bottom();
translate([0, pcb[1]*1.5,0])
	//translate([0,-extra_y,2*wall+pcb2floor+pcb2roof+pcb[2]])
	//rotate(a=[180,0,0])
lid();
