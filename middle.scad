
include <_setup.scad>;

module middle(
		lens_dim = LENS_DIM,
		lens_dist = LENS_DIST,
		lens_r = LENS_CORNER_R,
		screen_dim = SCREEN_DIM,
		screen_dist = SCREEN_DIST,
		screen_r = SCREEN_CORNER_R,
		thickness_housing = HOUSING_THICKNESS,
	) {

	difference() {
		hull() {
			linear_extrude(0.1)
			offset(r = TOLERANCE_FIT + thickness_housing)
			rounded_square([screen_dim[0], screen_dim[1]], screen_r);

			translate([0, 0, screen_dist])
			scale([1, 1, -1])
			linear_extrude(0.1)
			offset(r = TOLERANCE_FIT + thickness_housing)
			rounded_square([lens_dim[0], lens_dim[1]], lens_r);
		}
		hull() {
			scale([1, 1, -1])
			linear_extrude(0.1)
			rounded_square([screen_dim[0], screen_dim[1]], screen_r);

			translate([0, 0, screen_dist])
			linear_extrude(0.1)
			rounded_square([lens_dim[0], lens_dim[1]], lens_r);
		}
	}
}
