
include <_setup.scad>;

module strap_buckle(
		clip_dim = STRAP_CLIP_DIM,
		strap_dim = STRAP_DIM,
		surround = STRAP_CLIP_SURROUND,
		thickness = STRAP_CLIP_THICKNESS,
	) {

	translate([0, 0, clip_dim[1]])
	rotate([0, 180]) {
		linear_extrude(thickness)
		smooth(1)
		shape_strap_buckle();

		linear_extrude(clip_dim[1] - strap_dim[1] + TOLERANCE_CLEAR)
		smooth(1)
		shape_strap_buckle(clear = 1);

		linear_extrude(clip_dim[1])
		shape_strap_buckle(clear = 2);

		strap_clip_ring();
	}
}

module shape_strap_buckle(
		clear = 0, // number of strap slots to remove
		clip_dim = STRAP_CLIP_DIM,
		strap_dim = STRAP_DIM,
		surround = STRAP_CLIP_SURROUND,
	) {

	strap_surround_dim = [
		strap_dim[0] + (TOLERANCE_CLEAR + surround) * 2,
		(strap_dim[1] + (TOLERANCE_CLEAR + surround) * 2) * 2 - surround,
	];

	module shape() {
		hull() {
			circle(clip_dim[0] / 2 + TOLERANCE_FIT + surround);
			translate([0, clip_dim[0] / 2])
			square([clip_dim[0] + surround * 4, 1], true);
		}

		translate([0, clip_dim[0] / 2 + strap_surround_dim[1] / 2])
		square(strap_surround_dim, true);
	}

	difference() {
		smooth_acute(strap_surround_dim[1] / 4)
		shape();

		circle(clip_dim[0] / 2 + TOLERANCE_FIT);

		// strap holes
		translate([0, clip_dim[0] / 2 + surround + (strap_dim[1] + TOLERANCE_CLEAR * 2) / 2])
		for (y = [0, strap_dim[1] + TOLERANCE_CLEAR * 2 + surround])
		translate([0, y])
		offset(r = TOLERANCE_CLEAR)
		square(strap_dim, true);

		// clearance
		translate([0, clip_dim[0] / 2 + strap_surround_dim[1]])
		offset(r = TOLERANCE_CLEAR)
		square([strap_dim[0], (surround + strap_dim[1] + TOLERANCE_CLEAR) * 2 * clear], true);
	}
}

module strap_clip_ring(
		clip_dim = STRAP_CLIP_DIM,
		offset = 0
		) {
	translate([0, 0, clip_dim[1] / 2])
	rotate_extrude()
	translate([clip_dim[0] / 2 + clip_dim[1] / 2 - TOLERANCE_CLEAR, 0])
	rotate([0, 0, 90])
	semicircle_true(clip_dim[1] / 2 + offset);
}

module shape_strap_clip(
		clip_dim = STRAP_CLIP_DIM,
		thickness = STRAP_CLIP_THICKNESS,
	) {
	difference() {
		circle(clip_dim[0] / 2);
		circle(clip_dim[0] / 2 - thickness);
	}
}

module strap_clip(
		clip_dim = STRAP_CLIP_DIM,
		strap_dim = STRAP_DIM,
		thickness = STRAP_CLIP_THICKNESS,
	) {

	difference() {
		union() {
			linear_extrude(clip_dim[1], convexity = 2)
			shape_strap_clip();

			// make top printable
			intersection() {
				linear_extrude(clip_dim[1])
				hull()
				shape_strap_clip();

				translate([0, clip_dim[0] / 2 - thickness, -clip_dim[0] / 2 + clip_dim[1]])
				resize([clip_dim[0], clip_dim[0], clip_dim[0]])
				rotate([-45, 0])
				translate([0, 0, 0])
				cube(clip_dim[0], true);
			}
		}

		// center cutout - useless
		*translate([0, 0, clip_dim[1] / 2])
		cube([clip_dim[0] * 0.25, clip_dim[0] + 0.2, clip_dim[1] + 0.2], true);

		// clip ring inset
		strap_clip_ring(offset = TOLERANCE_FIT);

		// make bottom printable
		translate([0, -clip_dim[0], 0])
		resize([clip_dim[0], clip_dim[0] + thickness, clip_dim[0]])
		rotate([45, 0])
		translate([0, clip_dim[0] / 2, 0])
		cube(clip_dim[0], true);
	}
}

$fs = 0.5;

strap_buckle();
% strap_clip();
