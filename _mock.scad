
include <_setup.scad>;
use <bottom.scad>;
use <middle.scad>;
use <strap.scad>;
use <top.scad>;

//*
color("silver")
head();

//*
mock_ipd();

//show_half(r = [0, 0, -90])
{

//*
	top();

// strap buckle
//*
	pos_strap_clips()
	rotate([0, 0, 25])
	strap_buckle();

*
	mock_lens();

	translate([TOLERANCE_CLOSE, 0]) {
//*
		middle();

//*
		mock_dvr();

//*
		dvr_buttons();

//*
		mock_vrx();

*
		mock_screen();

//*
%
		translate([LENS_DIST + TOLERANCE_CLOSE + SCREEN_DIST + TOLERANCE_CLOSE + SCREEN_DIM[2] + TOLERANCE_FIT + HOUSING_THICKNESS, 0])
		rotate([0, 180])
		bottom();
	}
}

module mock_dvr() {
	pos_dvr()
	dvr_eachine_pro(case = false);
}

module mock_ipd() {
	color("magenta")
	reflect(x = false)
	translate([0, IPD / 2])
	rotate([0, 90])
	cylinder(h = 100, r = 0.5);
}

module mock_lens() {
	pos_lens()
//	scale([1, 1, -1])
	% diff_lens();
}

module mock_screen(dim = SCREEN_DIM, pos = SCREEN_POS, rot = SCREEN_ROT) {
	translate(pos)
	rotate(rot)
	% cube(dim, true);
}

module mock_vrx() {
	pos_vrx()
	vrx_rd945();
}
