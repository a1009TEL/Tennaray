shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform vec4 tint : source_color;
uniform float roughness : hint_range(0.0, 1.0);

uniform vec3 antennas_pos[64];
uniform vec2 antennas_feed_coeff[64];
uniform int antennas_count = 8;
uniform float lambda;

varying vec3 pos;
varying vec2 array_factor;

vec3 hsv_to_rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec3 cartesian_to_spherical(vec3 p) {
    float r = length(p);
    // Azimuth around the Y axis (-PI to PI)
    float phi = atan(p.z, p.x);
    // Elevation from the +Y axis (0 to PI)
    float theta = acos(clamp(p.y / r, -1.0, 1.0));
    return vec3(r, phi, theta);
}

vec3 spherical_to_cartesian(vec3 s) {
    float r = s.x;
    float phi = s.y;
    float theta = s.z;

    float sin_theta = sin(theta);

    return vec3(
        r * sin_theta * cos(phi), // x
        r * cos(theta),             // y
        r * sin_theta * sin(phi)  // z
    );
}

vec2 get_array_factor(vec3 p){
	vec2 af = vec2(0.0);
	for(int i = 0; i < antennas_count; i++){
		float alpha = TAU / lambda * dot(normalize(p), antennas_pos[i]);
		vec2 array_element = vec2(
			cos(alpha)*antennas_feed_coeff[i].x - sin(alpha)*antennas_feed_coeff[i].y, 
			cos(alpha)*antennas_feed_coeff[i].y + sin(alpha)*antennas_feed_coeff[i].x
		);
		af += array_element;
	}
	return af;
}

void vertex() {
	pos = VERTEX;
	
	float eps = 0.001;
	
	array_factor = get_array_factor(pos);
	
	vec3 p_px = spherical_to_cartesian(cartesian_to_spherical(pos) + vec3(0.0, eps, 0.0));
	if (length(p_px*length(get_array_factor(p_px)) - VERTEX*length(get_array_factor(pos))) == 0.0)
		p_px = spherical_to_cartesian(cartesian_to_spherical(pos) + vec3(0.0, 90.0, eps));
	vec3 p_py = spherical_to_cartesian(cartesian_to_spherical(pos) + vec3(0.0, 0.0, eps));
	
	vec3 p  = VERTEX*length(get_array_factor(pos));
	vec3 px = p_px*length(get_array_factor(p_px));
	vec3 py = p_py*length(get_array_factor(p_py));
	
	VERTEX = p;
	NORMAL = normalize(cross(-py + p, px - p));
}

void fragment() {
	ALBEDO = hsv_to_rgb(vec3((atan(array_factor.y, array_factor.x)+PI)/(2.0*PI), 1.0, 1.0)) * (-exp(-length(array_factor))+1.0);
	ROUGHNESS = roughness;
	METALLIC = 0.0;
}