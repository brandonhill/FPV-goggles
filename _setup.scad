
include <_conf.scad>;

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

module head(pos = HEAD_POS, scale = HEAD_SCALE) {
	scale(scale)
	translate(pos)
	scale(20) // weird
	import("head.stl");
}
