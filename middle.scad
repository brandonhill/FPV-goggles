
include <_setup.scad>;

DVR_BTN_DIM = [4, 1];
DVR_SWITCH_DIM = SWITCH_TACT_MICRO_DIM;

module dvr_buttons(
		dvr_board_dim = DVR_EACHINE_PRO_BOARD_DIM,
		dvr_pos = DVR_POS,
		dvr_btn_dim = DVR_BTN_DIM,
		housing_thickness = HOUSING_THICKNESS,
		lens_housing_dim = LENS_HOUSING_DIM,
		switch_dim = DVR_SWITCH_DIM,
		offset = 0,
	) {

	offset_z = switch_dim[2] + TOLERANCE_CLEAR;
	base_height = lens_housing_dim[1] / 2 + dvr_pos[2] - offset_z;
	space_height = lens_housing_dim[1] / 2 - housing_thickness - TOLERANCE_CLEAR + dvr_pos[2] - offset_z;

	pos_dvr()
	translate([0, 0, offset_z]) {

		// join
		hull()
		pos_dvr_eachine_pro_switches()
		cylinder(h = PRINT_LAYER * 2, r = housing_thickness);

		pos_dvr_eachine_pro_switches()
		difference() {
			union() {
				// flange
				cylinder(h = PRINT_LAYER * 2, r = dvr_btn_dim[0] / 2 + housing_thickness / 2);

				// base
				cylinder(h = base_height, r = dvr_btn_dim[0] / 2 + offset);

				// raised portion
				translate([0, 0, base_height])
//				cylinder(h = dvr_btn_dim[1], r = dvr_btn_dim[0] / 2 + offset);
				cylinder(h = dvr_btn_dim[1], r1 = dvr_btn_dim[0] * 0.5 + offset, r2 = dvr_btn_dim[0] * 0.3 + offset);

				// retainer
				translate([0, 0, space_height / 2])
				cube([housing_thickness / 2, dvr_btn_dim[0] + housing_thickness * 2, space_height], true);
			}

			// concave top
			translate([0, 0, base_height + dvr_btn_dim[1]])
			resize([dvr_btn_dim[0], dvr_btn_dim[0], dvr_btn_dim[1]])
			sphere(dvr_btn_dim[0] / 2);
		}
	}
}

module screw_surround_support(
		h,
		surround = SCREW_SURROUND,
	) {

	translate([0, 0, h])
	rotate([-90, 0, -90])
	linear_extrude(surround, center = true)
	polygon([
		[0, 0],
		[-surround / 2, 0],
		[-surround / 2, h],
		[0, h],
		[h * 2/3, 0],
	]);
}

module middle(
		dvr_board_dim = DVR_EACHINE_PRO_BOARD_DIM,
		dvr_pos = DVR_POS,
		dvr_screw_dim = DVR_EACHINE_PRO_SCREW_DIM,
		lens_dim = LENS_DIM,
		lens_dist = LENS_DIST,
		lens_housing_dim = LENS_HOUSING_DIM,
		lens_r = LENS_CORNER_R,
		name = NAME,
		name_font = NAME_FONT,
		name_size = NAME_SIZE,
		screen_dim = SCREEN_DIM,
		screen_dist = SCREEN_DIST,
		screen_r = SCREEN_CORNER_R,
		screw_dim = FACEPLATE_SCREW_DIM,
		screw_length = FACEPLATE_SCREW_LENGTH,
		screw_surround = SCREW_SURROUND,
		thickness_housing = HOUSING_THICKNESS,
		vrx_av_pos = VRX_AV_OUT_POS,
		vrx_av_spacing = VRX_AV_OUT_SPACING,
		vrx_dim = VRX_DIM,
		vrx_board_dim = VRX_BOARD_DIM,
		vrx_board_pos = VRX_BOARD_POS,
		vrx_pos = VRX_POS,
		vrx_screw_dim = VRX_SCREW_DIM,
	) {

	av_cutout_clearance = 5 + thickness_housing;
	av_cutout_dim = [
		vrx_av_spacing + av_cutout_clearance * 2,
		lens_housing_dim[1] / 2 - (vrx_board_dim[1] / 2 - (vrx_pos[2] + vrx_board_pos[1])),
		av_cutout_clearance * 2];

	module pos_av_jacks() {
		translate([
			vrx_av_pos[0] + vrx_av_spacing / 2,
			-(lens_housing_dim[0] / 2 + vrx_pos[1] - av_cutout_dim[2] / 2),
			-vrx_board_dim[1] / 2 + vrx_board_pos[1] - TOLERANCE_CLEAR - av_cutout_dim[1] / 2,
			])
		pos_vrx()
		children();
	}

	module inner() {
		difference() {
			translate([lens_dist, 0])
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

			// A/V jacks cutout
			pos_av_jacks()
			cube(av_cutout_dim, true);
		}
	}

	module outer() {
		difference() {
			translate([lens_dist, 0])
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

			// A/V jacks cutout
			translate([0, -thickness_housing, -thickness_housing])
			pos_av_jacks()
			cube([
				av_cutout_dim[0] - thickness_housing * 2,
				av_cutout_dim[1] - thickness_housing,
				av_cutout_dim[2] - thickness_housing], true);
		}
	}

	difference() {
		union() {
			outer();

			// screw surrounds
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

		diff_dvr();
		dvr_buttons(offset = TOLERANCE_CLEAR);

		diff_vrx();
	}

	// lens retainer
	difference() {
		reflect(x = false, z = true)
		translate([
			lens_dist + lens_dim[2][0] + TOLERANCE_CLEAR * 2,
			lens_housing_dim[0] / 2 - thickness_housing,
			lens_housing_dim[1] / 2 - thickness_housing
			])
		rotate([0, -90, 0])
		scale(-1)
		linear_extrude(thickness_housing * 3, scale = 0)
		resize([thickness_housing * 2.5, thickness_housing * 2.5])
		polygon([
			[0, 0],
			[0, 1],
			[1, 0],
		]);

		diff_lens(); // not sure if there's much accuracy/point to this..
	}

	// name
	translate([0, vrx_dim[2] / 2]) // tweak
	translate([lens_dist + screen_dist / 2, 0, lens_housing_dim[1] / 2])
	show_half(r = [90, 0])
	translate([0, 0, -5 + thickness_housing / 2])
	linear_extrude_chamfer(10, thickness_housing / 2, convexity = 3)
	rotate([0, 0, 90])
	text(name, font = name_font, halign = "center", size = name_size, valign = "center");

	// DVR mount
	pos_dvr()
	let (h = lens_housing_dim[1] / 2 - thickness_housing + dvr_pos[2]) {

		// screw posts
		pos_dvr_eachine_pro_screws()
		translate([0, 0, dvr_board_dim[2] / 2]) {
			rotate([0, 0, 22.5])
			screw_surround(
				dim = dvr_screw_dim,
				h = h,
				holes = true,
				walls = screw_surround,
				tolerance = TOLERANCE_FIT,
				fn = 8
			);

			// make printable
			translate([0, -(dvr_screw_dim[0] / 2 + TOLERANCE_FIT + screw_surround)])
			screw_surround_support(h);
		}

		// edge retainer
		translate([
			-(dvr_board_dim[0] - thickness_housing) / 2,
			0,
			-(dvr_board_dim[2] + TOLERANCE_FIT + thickness_housing / 2)])
		difference() {
			cube([thickness_housing, dvr_board_dim[1], thickness_housing], true);

			// make bottom edge printable
			translate([-thickness_housing / 2, -dvr_board_dim[1] / 2])
			rotate([0, 0, 45])
			translate([thickness_housing, -thickness_housing])
			cube(thickness_housing * 2, true);
		}
	}

	// VRx screw posts
	pos_vrx()
	pos_vrx_rd945_screws()
	translate([0, 0, vrx_board_dim[2] / 2])
	let(h = lens_housing_dim[0] / 2 + vrx_pos[1]) {
		rotate([0, 0, 22.5])
		screw_surround(
			dim = vrx_screw_dim,
			h = h,
			holes = true,
			walls = screw_surround,
			tolerance = TOLERANCE_FIT,
			fn = 8
		);

		// make printable
		rotate([0, 0, 90])
		translate([0, -(vrx_screw_dim[0] / 2 + TOLERANCE_FIT + screw_surround)])
		screw_surround_support(h);
	}
}
