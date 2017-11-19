
include <_setup.scad>;

module bottom(
		dim = SCREEN_HOUSING_DIM,
		lens_dist = LENS_DIST,
		r = SCREEN_CORNER_R,
		screen_dim = SCREEN_DIM,
		screen_screen_dim = SCREEN_SCREEN_DIM,
		screen_dist = SCREEN_DIST,
		screw_dim = FACEPLATE_SCREW_DIM,
		screw_surround = SCREW_SURROUND,
		thickness_housing = HOUSING_THICKNESS,
	) {

	brace_width = (dim[1] - screen_dim[1]) / 2 - TOLERANCE_FIT;
	h = screen_dim[2] + TOLERANCE_FIT + thickness_housing;
	chamfer = h / 2;

	module shape() {
		smooth(thickness_housing)
		square(dim, true);
	}

	module solid(offset = 0) {

		_chamfer = max(0, chamfer + offset / 2);

		translate([lens_dist + screen_dist + h / 2, 0])
		rotate([90, 0, -90])
		translate([0, 0, -h / 2])
		hull() {
			translate([0, 0, -offset])
			linear_extrude(0.1)
			offset(r = -_chamfer + offset)
			shape();

			translate([0, 0, _chamfer - offset])
			linear_extrude(h - _chamfer + offset)
			offset(r = offset)
			shape();
		}
	}

	difference() {
		union() {
			difference() {
				solid();
				translate([-0.005, 0])
				solid(-thickness_housing);
			}

			// screen screw surrounds
			intersection() {
				solid();

				pos_screen_screws() {
					translate([0, 0, -screen_screen_dim[2] - TOLERANCE_FIT])
					scale([1, 1, -1])
					screw_surround(
						attach_walls = true,
						dim = screw_dim,
						end = "rounded",
						h = h,
						holes = true,
						tolerance = TOLERANCE_CLOSE,
						walls = screw_surround);

					translate([0, 0, -h * 2 + chamfer + thickness_housing])
					cylinder(h = h, r = screw_dim[1] / 2 + TOLERANCE_CLEAR + thickness_housing);

					translate([-10, -(screw_dim[0] / 2 + thickness_housing - brace_width / 2), -h / 2])
					cube([thickness_housing, brace_width, h], true);

					translate([-10, -(screw_dim[0] / 2 + thickness_housing - brace_width / 2), -h / 2 - TOLERANCE_FIT - screen_screen_dim[2]])
					cube([thickness_housing, brace_width * 2, h], true);
				}
			}
		}

		pos_screen_screws() {
			translate([0, 0, -h / 2])
			cylinder(h = h + 0.2, r = screw_dim[0] / 2 + TOLERANCE_CLOSE, center = true);

			translate([0, 0, -h * 2 + chamfer])
			cylinder(h = h, r = screw_dim[1] / 2 + TOLERANCE_CLEAR);
		}

		diff_screen_switches();
	}
}
