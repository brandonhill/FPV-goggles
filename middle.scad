
include <_setup.scad>;

module middle(
		lens_dim = LENS_DIM,
		lens_dist = LENS_DIST,
		lens_r = LENS_CORNER_R,
		screen_dim = SCREEN_DIM,
		screen_dist = SCREEN_DIST,
		screen_r = SCREEN_CORNER_R,
		screw_dim = FACEPLATE_SCREW_DIM,
		screw_length = FACEPLATE_SCREW_LENGTH,
		screw_surround = SCREW_SURROUND,
		thickness_housing = HOUSING_THICKNESS,
	) {

	module inner() {
		rotate([90, 0, 90])
		hull() {
			translate([0, 0, screen_dist])
			linear_extrude(0.1)
			offset(r = TOLERANCE_FIT)
			rounded_square([screen_dim[0], screen_dim[1]], screen_r);

			scale([1, 1, -1])
			linear_extrude(0.1)
			offset(r = TOLERANCE_FIT)
			rounded_square([lens_dim[0], lens_dim[1]], lens_r);
		}
	}

	module outer() {
		rotate([90, 0, 90])
		hull() {
			linear_extrude(0.1)
			offset(r = TOLERANCE_FIT + thickness_housing)
			rounded_square([lens_dim[0], lens_dim[1]], lens_r);

			translate([0, 0, screen_dist])
			scale([1, 1, -1])
			linear_extrude(0.1)
			offset(r = TOLERANCE_FIT + thickness_housing)
			rounded_square([screen_dim[0], screen_dim[1]], screen_r);
		}
	}

	difference() {
		union() {
			outer();

			// screw surrounds
			translate([-lens_dist, 0])
			pos_faceplate_screws()
			rotate([90, 0, 90])
			screw_surround(
				attach_walls = true,
				dim = screw_dim,
				end = "rounded",
				h = screw_length - screw_surround,
				holes = true,
				tolerance = TOLERANCE_CLOSE,
				walls = screw_surround);
		}

		inner();
	}

	// lens retainer
	reflect(x = false, z = true)
	translate([lens_dim[2][0] + TOLERANCE_CLEAR, lens_dim[0] / 2, lens_dim[1] / 2])
	rotate([0, -90, 0])
	scale(-1)
	linear_extrude(thickness_housing * 3, scale = 0)
	resize([thickness_housing * 3, thickness_housing * 3])
	polygon([
		[0, 0],
		[0, 1],
		[1, 0],
	]);
}
