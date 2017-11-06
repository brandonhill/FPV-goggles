
include <_setup.scad>;

module bottom(
		lens_dist = LENS_DIST,
		r = SCREEN_CORNER_R,
		screen_dim = SCREEN_DIM,
		screen_dist = SCREEN_DIST,
		thickness_housing = HOUSING_THICKNESS,
	) {

	h = screen_dim[2] + TOLERANCE_FIT + thickness_housing;

	rotate([90, 0, 90])
	difference() {
		linear_extrude(h)
		offset(r = TOLERANCE_FIT + thickness_housing)
		rounded_square([screen_dim[0], screen_dim[1]], r);

		translate([0, 0, thickness_housing])
		linear_extrude(h)
		offset(r = TOLERANCE_FIT)
		rounded_square([screen_dim[0], screen_dim[1]], r);
	}
}
