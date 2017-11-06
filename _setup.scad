
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
	rotate([0, 0, 90])
	translate(pos)
	scale(20) // weird
	import("head.stl");
}

module pos_faceplate_screws(pos = FACEPLATE_SCREW_POS) {
	reflect(x = false, z = true)
	translate(pos)
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
