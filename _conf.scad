/******************************************************************************
 * Config
 */

include <../BH-Lib/all.scad>;

TOLERANCE_CLOSE = 0.15;
TOLERANCE_FIT = 0.2;
TOLERANCE_CLEAR = 0.25;

DVR_DIM = [38, 25, 5];

FACEPLATE_CORNER_R = 5;
FACEPLATE_DIM = [130, 30, 60];
FACEPLATE_OFFSET = 9;
FACEPLATE_SCREW_DIM = SCREW_M2_SOCKET_DIM;
FACEPLATE_SCREW_LENGTH = 8;
FACEPLACE_WIDTH = 10; // approx.

HEAD_SCALE = 1.333; // scalar or vector3

HOUSING_THICKNESS = 1.5;

IPD = 70; // for sizing of head model used to diff faceplate

LENS_CORNER_R = 0;
LENS_DIM = [120, 80, [1.1, 8]]; // h is [min, max] along edges
LENS_DIST = 40;

NOSE_ANGLE = 30;
NOSE_DIM = [60, 25, 40];
NOSE_SCALING = 0.4;

SCREEN_CORNER_R = 0;
SCREEN_DIM = [120, 80, 15];

SCREW_SURROUND = 1.5;

STRAP_CLIP_R = 12;
STRAP_CLIP_SURROUND = 4;
STRAP_CLIP_THICKNESS = 1.5;
STRAP_DIM = [40, 2];

VRX_ANT_SPACING = 46;
VRX_DIM = [63.75, 78, 8];

/******************************************************************************
 * Setup
 */

DVR_POS = [-(LENS_DIM[0] - DVR_DIM[0]) / 2, -(LENS_DIM[1] - DVR_DIM[2]) / 2, -(LENS_DIST + LENS_DIM[2][1] + 1 + DVR_DIM[1] / 2)];
DVR_ROT = [90, 0];

HEAD_POS = [0, 68, -133]; // centred on pupils

LENS_HOUSING_DIM = [
	LENS_DIM[0] + (TOLERANCE_CLEAR + HOUSING_THICKNESS) * 2,
	LENS_DIM[1] + (TOLERANCE_CLEAR + HOUSING_THICKNESS) * 2];
LENS_POS = [0, 0, -(LENS_DIST + LENS_DIM[2][1] / 2)];

SCREEN_DIST = LENS_DIM[2][1] + TOLERANCE_CLEAR + VRX_DIM[0] + TOLERANCE_CLEAR; // from lens to screen
SCREEN_POS = [0, 0, -(LENS_DIST + SCREEN_DIST + SCREEN_DIM[2] / 2)];
SCREEN_ROT = [0, 0, 0];

FACEPLATE_SCREW_POS = [
	LENS_DIST,
	FACEPLATE_DIM[0] * 0.3,
	(LENS_HOUSING_DIM[1] + FACEPLATE_SCREW_DIM[0]) / 2 + TOLERANCE_CLOSE];

STRAP_CLIP_DIM = [STRAP_CLIP_R * 2, STRAP_DIM[1] * 2 + STRAP_CLIP_THICKNESS]; // [dia., height]

VRX_POS = [
	(LENS_DIM[0] - VRX_DIM[1]) / 2,
	(LENS_DIM[1] - VRX_DIM[2]) / 2,
	-(LENS_DIST + LENS_DIM[2][1] + TOLERANCE_CLEAR + VRX_DIM[0] / 2)];
VRX_ROT = [90, 90, 0];
