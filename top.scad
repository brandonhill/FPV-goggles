
include <_setup.scad>;
use <strap.scad>;

module top(
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
		screw_dim = FACEPLATE_SCREW_DIM,
		screw_length = FACEPLATE_SCREW_LENGTH,
		screw_surround = SCREW_SURROUND,
		seam_overlap = 0,//SEAM_OVERLAP,
		clip_dim = STRAP_CLIP_DIM,
		clip_surround = STRAP_CLIP_SURROUND,
		thickness_housing = HOUSING_THICKNESS,
		thickness_faceplate = FACEPLACE_WIDTH,
	) {

	depth = dim[2] + seam_overlap;
	x_offset = dim[2] - (lens_dist + seam_overlap);

	steps_depth = 20;//round(depth / seam_overlap);
	print(["Steps", steps_depth]);

	module inner() {
		translate([0, 0, -0.1])
		for (i = [0 : steps_depth - 1])
		hull()
		for (step = [0, 1])
		translate([depth * (i + step) / steps_depth, 0])
		rotate([90, 0, 90])
//		scale([1, 1, step ? -1 : 1])
		linear_extrude(0.1, convexity = 10, center = true)
		shape(
			offset_point(lens_dim, -1),
			dim,
			lens_r,
			faceplate_r,
			1 - (i + step) * 1.0 / steps_depth,
			inner = true);
	}

	module outer() {
		for (i = [0 : steps_depth - 1])
		hull()
		for (step = [0, 1])
		translate([depth * (i + step) / steps_depth, 0])
		rotate([90, 0, 90])
		scale([1, 1, step ? -1 : 1])
		linear_extrude(0.1, convexity = 10)
		shape(
			offset_point(lens_dim, thickness_housing + TOLERANCE_FIT),
			offset_point(dim, thickness_faceplate),
			lens_r + TOLERANCE_FIT + thickness_housing,
			faceplate_r + thickness_faceplate,
			1 - (i + step) / steps_depth);
	}

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

	difference() {
//		translate([lens_dist + seam_overlap, 0])
		translate([-x_offset, 0])
		intersection() {
			union() {
//				show_half()
				difference() {
					outer();
					inner();
				}

				// nose surround
				intersection() {
					outer();

					translate([lens_dist + nose_dim[2] / 2, 0, -lens_dim[1] / 2 - thickness_housing / 2])
					rotate([0, nose_angle])
					translate([-nose_dim[2], 0])
					rotate([90, 0, 90])
					linear_extrude(nose_dim[2], scale = nose_scaling)
					smooth_acute(faceplate_r)
					shape_nose_surround();
				}

				// screw surrounds
				translate([x_offset, 0])
				difference() {
					translate([-screw_surround, 0])
					pos_faceplate_screws()
					screw_surround(
						attach_walls = true,
						dim = screw_dim,
						h = screw_surround,
						holes = true,
						mock = true,
						tolerance = TOLERANCE_CLOSE,
						walls = screw_surround);

					inner();
				}
			}

			// round top edges
			translate([dim[2], 0])
			union() {
				hull()
				rotate([90, 0])
				reflect()
				translate([-depth + faceplate_r * 2, dim[1] / 2 + thickness_faceplate - faceplate_r * 2])
				cylinder(h = lens_dim[0] * 2, r = faceplate_r * 2, center = true);

				cube([lens_dist * 2, lens_dim[0] * 2, lens_dim[1] * 2], true);
			}
		}

		// head
		scale(1.05)
		head();

		// seam
		*#
		translate([0, 0, -(lens_dist + seam_overlap)])
		cube(offset_point([lens_dim[0], lens_dim[1], seam_overlap + TOLERANCE_FIT * 2], TOLERANCE_FIT + thickness_housing / 2), true);
	}

	// strap clips
	pos_strap_clips()
	strap_clip();
}
