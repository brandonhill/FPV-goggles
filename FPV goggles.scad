
include <_setup.scad>;

module fpv_goggle_bot(
		lens_dist = LENS_DIST,
		r = SCREEN_CORNER_R,
		screen_dim = SCREEN_DIM,
		screen_dist = SCREEN_DIST,
		thickness_housing = HOUSING_THICKNESS,
	) {

	h = screen_dim[2] + TOLERANCE_FIT + thickness_housing;

	difference() {
		linear_extrude(h)
		offset(r = TOLERANCE_FIT + thickness_housing)
		rounded_square([screen_dim[0], screen_dim[1]], r);

		translate([0, 0, thickness_housing])
		linear_extrude(h)
		rounded_square([screen_dim[0], screen_dim[1]], r);
	}
}

module fpv_goggle_mid(
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

module fpv_goggle_top(
		dim = FACEPLATE_DIM,
		faceplate_r = FACEPLATE_CORNER_R,
		lens_dim = LENS_DIM,
		lens_dist = LENS_DIST,
		lens_r = LENS_CORNER_R,
		nose_angle = NOSE_ANGLE,
		nose_dim = NOSE_DIM,
		nose_offset = 30,
		nose_scaling = NOSE_SCALING,
		offset = FACEPLATE_OFFSET,
		seam_overlap = 0,//SEAM_OVERLAP,
		thickness_housing = HOUSING_THICKNESS,
		thickness_faceplate = FACEPLACE_WIDTH,
		vrx_ant_spacing = VRX_ANT_SPACING,
	) {

	depth = dim[2] + seam_overlap;

	steps_depth = 20;//round(depth / seam_overlap);
	print(["Steps", steps_depth]);

	module shape(
			dim0,
			dim1,
			r0 = 0,
			r1 = 0,
			i = 0, // percentage of depth, used to determine shape across z
			inner = false,
			nose = true,
		) {

		lookup_x = [
			[0, dim0[0]],
//			[(seam_overlap + (inner ? 0 : thickness_housing)) / depth, dim0[0]],
			[inner ? (lens_dist - offset) / depth : 1, dim1[0]],
		];
		lookup_y = [
			[0, dim0[1]],
//			[(seam_overlap + (inner ? 0 : thickness_housing)) / depth, dim0[1]],
			[(lens_dist - offset) / depth, dim1[1]],
		];
		lookup_r = [
			[0, r0],
//			[(seam_overlap + (inner ? 0 : thickness_housing)) / depth, r0],
			[1, r1],
		];

		rounded_square([lookup(i, lookup_x), lookup(i, lookup_y)], lookup(i, lookup_r));
	}

	module shape_nose_surround() {
		polygon([
			[-nose_dim[0] / 2, 0],
			[0, nose_dim[1]],
			[nose_dim[0] / 2, 0],
		]);

		translate([0, -nose_dim[1] / 2])
		square([nose_dim[0] * 2, nose_dim[1]], true);
	}

	module inner() {
		translate([0, 0, -0.1])
		for (i = [0 : steps_depth - 1])
		hull()
		for (step = [0, 1])
		translate([0, 0, depth * (i + step) / steps_depth])
		linear_extrude(0.1, convexity = 10)
		shape(offset_point(lens_dim, -1), dim, lens_r, faceplate_r, (i + step) * 1.0 / steps_depth, inner = true);
	}

	module outer() {
		for (i = [0 : steps_depth - 1])
		hull()
		for (step = [0, 1])
		translate([0, 0, depth * (i + step) / steps_depth])
		linear_extrude(0.1, convexity = 10)
		shape(
			offset_point(lens_dim, thickness_housing + TOLERANCE_FIT),
			offset_point(dim, thickness_faceplate),
			lens_r + TOLERANCE_FIT + thickness_housing,
			faceplate_r + thickness_faceplate,
			(i + step) / steps_depth);
	}

	difference() {
		translate([0, 0, -(lens_dist + seam_overlap)])
		intersection() {
			union() {
				difference() {
					outer();
					inner();
				}

				intersection() {
					outer();

					// nose surround
					translate([0, -lens_dim[1] / 2 - thickness_housing / 2])
					rotate([-nose_angle, 0, 0])
					translate([0, 0, nose_dim[2]])
					scale([1, 1, -1])
					linear_extrude(nose_dim[2], scale = nose_scaling)
					smooth_acute(faceplate_r)
					shape_nose_surround();
				}
			}

			// round top edges
			union() {
				hull()
				rotate([0, 90])
				reflect()
				translate([-depth + faceplate_r, dim[1] / 2 + thickness_faceplate - faceplate_r])
				cylinder(h = lens_dim[0] * 2, r = faceplate_r, center = true);

				cube([lens_dim[0] * 2, lens_dim[1] * 2, lens_dist * 2 + faceplate_r], true);
			}
		}

		// head
		rotate([90, 0, 180]) {
			scale(1.05)
			head();
		}

		// seam
		*#
		translate([0, 0, -(lens_dist + seam_overlap)])
		cube(offset_point([lens_dim[0], lens_dim[1], seam_overlap + TOLERANCE_FIT * 2], TOLERANCE_FIT + thickness_housing / 2), true);
	}
}
