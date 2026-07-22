shader_type spatial;

render_mode unshaded;

uniform vec4 color : source_color;
uniform float scaling;
uniform int secondary = 3;
uniform float thickness;

uniform float radius_1;
uniform float radius_2;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV - vec2(0.5);
	
	// big grid
	vec2 uv2 = uv * scaling;
	float value_x = mod(uv2.x, 1.0);
	if (value_x > 0.5)
		value_x = -value_x + 1.0;
	float value_y = mod(uv2.y, 1.0);
	if (value_y > 0.5)
		value_y = -value_y + 1.0;
	float value = -clamp(min(value_x, value_y)/thickness, 0.0, 1.0) + 1.0;
	
	// small grid
	uv2 *= float(secondary);
	value_x = mod(uv2.x, 1.0);
	if (value_x > 0.5)
		value_x = -value_x + 1.0;
	value_y = mod(uv2.y, 1.0);
	if (value_y > 0.5)
		value_y = -value_y + 1.0;
	float value2 = -clamp(min(value_x, value_y)/thickness, 0.0, 1.0) + 1.0;
	
	value = max(value, value2);
	
	float dist = length(uv);
	float fading_coeff;
	if (dist < radius_1)
		fading_coeff = 1.0;
	else if (dist > radius_2)
		fading_coeff = 0.0;
	else {
		float offset = (dist - radius_2)/abs(radius_1 - radius_2);
		fading_coeff = 2.0*pow(offset, 3.0) + 3.0*pow(offset, 2.0);
	}
	
	ALBEDO = color.rgb;
    ALPHA = value * fading_coeff;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
