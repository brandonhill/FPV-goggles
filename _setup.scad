
include <_conf.scad>;

module diff_dvr() {
	pos_dvr()
	dvr_eachine_pro(case = false, tolerance = TOLERANCE_CLEAR);
}

module diff_lens(
		dim = LENS_DIM,
		offset = 0,
	) {

	r = 380;

	intersection() {
		cube([dim[0] + offset * 2, dim[1] + offset * 2, dim[2][1] + offset * 2], true);

		translate([0, 0, -r + dim[2][1] / 2])
		sphere_true(r + offset);
	}

	// dim checks
	*union() {
		#cube([10, 10, dim[2][1]], true);

		#translate([0, 0, -(dim[2][1] - dim[2][0]) / 2])
		cube([dim[0], dim[1], dim[2][0]], true);
	}
}

module diff_screen_switches() {
	screen_switches(tolerance = TOLERANCE_CLEAR);
}

module diff_vrx() {
	pos_vrx()
	vrx_rd945(tolerance = TOLERANCE_CLEAR, omit = ["power_jack"]);
}

module head(pos = HEAD_POS, scale = HEAD_SCALE) {
	scale(scale)
	rotate([0, 0, 90])
	translate(pos)
	scale(20) // weird
	import("head.stl");
}

module position(pos, rot) {
	translate(pos)
	rotate(rot)
	children();
}

module pos_dvr(pos = DVR_POS, rot = DVR_ROT) {
	position(pos, rot)
	children();
}

module pos_faceplate_screws(pos = FACEPLATE_SCREW_POS, rot = FACEPLATE_SCREW_ROT) {
	reflect(x = false, z = true)
	position(pos, rot)
	children();
}

module pos_lens(pos = LENS_POS, rot = LENS_ROT) {
	position(pos, rot)
	children();
}

module pos_screen(pos = SCREEN_POS, rot = SCREEN_ROT) {
	position(pos, rot)
	children();
}

module pos_screen_screws(pos = SCREEN_SCREW_POS, rot = SCREEN_SCREW_ROT) {
	reflect(x = false, z = true)
	position(pos, rot)
	children();
}

module pos_screen_switch(pos = SCREEN_SWITCH_POS, rot = SCREEN_SWITCH_ROT) {
	position(pos, rot)
	children();
}

module pos_screen_switches(spacing = SCREEN_SWITCH_SPACING) {
	for (x = [-1, 0, 1])
	translate([spacing * x, 0])
	children();
}

module pos_screen_switch_holes(
		board_dim = SCREEN_SWITCH_BOARD_DIM,
		offset = SCREEN_SWITCH_HOLE_OFFSET,
		spacing = SCREEN_SWITCH_HOLE_SPACING
	) {
	for (x = [0, spacing])
	translate(offset)
	translate([-board_dim[0] / 2 + x, board_dim[1] / 2, board_dim[2]])
	children();
}

module pos_strap_clips(
		dim = FACEPLATE_DIM,
		clip_dim = STRAP_CLIP_DIM,
		clip_surround = STRAP_CLIP_SURROUND,
		lens_dim = LENS_DIM,
		lens_dist = LENS_DIST,
		thickness_faceplate = FACEPLACE_WIDTH,
		thickness_housing = HOUSING_THICKNESS,
	) {

	a = atan(((dim[0] + thickness_faceplate * 2) - (lens_dim[0] + (TOLERANCE_FIT + thickness_housing) * 2)) / 2 / dim[2]);

	reflect(x = false)
	translate([lens_dist, lens_dim[0] / 2 + thickness_housing])
	rotate([0, 0, -a])
	translate([-(clip_dim[0] / 2 + TOLERANCE_FIT + clip_surround + TOLERANCE_CLEAR), 0])
	rotate([-90, 90, 0])
	children();
}

module pos_vrx(pos = VRX_POS, rot = VRX_ROT) {
	position(pos, rot)
	children();
}

module screen_switches(
		board_dim = SCREEN_SWITCH_BOARD_DIM,
		hole_offset = SCREEN_SWITCH_HOLE_OFFSET,
		hole_spacing = SCREEN_SWITCH_HOLE_SPACING,
		screw_dim = SCREEN_SWITCH_SCREW_DIM,
		switch_offset = SCREEN_SWITCH_OFFSET,
		tolerance = 0,
	) {
	pos_screen_switch() {
		color(COLOUR_PCB)
		difference() {

			// board
			translate([0, 0, board_dim[2] / 2])
			cube(board_dim, true);

			// holes
			for (x = [0, hole_spacing])
			translate(hole_offset)
			translate([-board_dim[0] / 2 + x, board_dim[1] / 2, board_dim[2] / 2])
			cylinder(h = board_dim[2] + 0.2, r = screw_dim[0] / 2, center = true);
		}

		// switches
		pos_screen_switches()
		translate(switch_offset)
		translate([0, 0, board_dim[2]])
		switch_tact(9.25, tolerance = tolerance);
	}
}
