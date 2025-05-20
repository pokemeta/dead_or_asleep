// ##########################
// #       Si-Ja, 2024      #
// # https://si-ja.itch.io/ #
// #                        #
// # Shader for prototyping #
// #                        #
// ##########################

shader_type spatial;

const float modifier_from_percent = 100.0;

uniform int x_axis_squares;                 /* How many squares should exist on x axis */
uniform int y_axis_squares;                 /* How many squares should exist on y axis */

uniform vec3 a_square_color : source_color; /* First color of the checkerboard */
uniform vec3 b_square_color : source_color; /* Second color of the checkerboard*/

uniform float movement_modifier_x : hint_range(-5, 5, 0.1) = 0.0;    /* How fast should the x axis colors move */
uniform float movement_modifier_y : hint_range(-5, 5, 0.1) = 0.0;    /* How fast should the y axis colors move */
uniform float movement_strenght : hint_range(-20, 20, 1) = 0.0;      /* Color movement speed modifier */

void fragment() {
	// Basic setup for few values
	ROUGHNESS = 1.0;
	METALLIC = 0.0;
	
	// Color setup on the board (how many times they need to appear)
	float x_steps = 1.0 / float(x_axis_squares);
	float y_steps = 1.0 / float(y_axis_squares);
	
	// Find if the pixel is in the even or odd step for x & y combination
	if (int(mod(floor((UV.x + TIME * movement_modifier_x * (movement_strenght / modifier_from_percent)) / x_steps), 2.0)) 
	== int(mod(floor((UV.y + TIME * movement_modifier_y * (movement_strenght / modifier_from_percent)) / y_steps), 2.0))) {
		ALBEDO = a_square_color;
	} else {
		ALBEDO = b_square_color;
	}
}