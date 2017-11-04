
include <_setup.scad>;
use <bottom.scad>;
use <middle.scad>;
use <strap.scad>;
use <top.scad>;

//*
color("silver")
head();

*
mock_ipd();

//translate([0, -50])
//show_half(r = [0, 0, -90])
rotate([90, 0, 180]) {

//*
	top();

// strap buckle
pos_strap_clips()
rotate([0, 0, -25])
strap_buckle();

*
	mock_lens();

//*
	translate([0, 0, -(LENS_DIST + TOLERANCE_CLOSE + SCREEN_DIST)])
	middle();

//*
	mock_dvr();

//*
	mock_vrx();

*
	mock_screen();

*
	translate([0, 0, -(LENS_DIST + TOLERANCE_CLOSE + SCREEN_DIST + TOLERANCE_CLOSE + SCREEN_DIM[2] + TOLERANCE_FIT + HOUSING_THICKNESS)])
	bottom();
}

module mock_dvr(dim = DVR_DIM, pos = DVR_POS, rot = DVR_ROT) {
	translate(pos)
	rotate(rot)
	% cube(dim, true);
}

module mock_ipd() {
	color("magenta")
	reflect(y = false)
	translate([IPD / 2, 0])
	rotate([90, 0])
	cylinder(h = 100, r = 0.5);
}

module mock_lens(pos = LENS_POS, rot = []) {
	translate(pos)
	rotate(rot)
	scale([1, 1, -1])
	% diff_lens();
}

module mock_screen(dim = SCREEN_DIM, pos = SCREEN_POS, rot = SCREEN_ROT) {
	translate(pos)
	rotate(rot)
	% cube(dim, true);
}

module mock_vrx(dim = VRX_DIM, pos = VRX_POS, rot = VRX_ROT) {
	%
	translate(pos)
	rotate(rot) {
		cube(dim, true);
		reflect(y = false)
		translate([VRX_ANT_SPACING / 2, dim[1] / 2])
		rotate([-90, 0])
		cylinder(h = 15, r = SMA_RAD);
	}
}
