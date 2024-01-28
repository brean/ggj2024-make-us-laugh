shader_type spatial;
render_mode cull_disabled, diffuse_toon;

uniform float speed : hint_range(-1, 1) = 0.0;

// colors
uniform sampler2D noise1;
uniform sampler2D noise2;
uniform sampler2D normal_map : hint_normal;
uniform vec4 color : source_color;
uniform vec4 edge_color : source_color;

// edges
uniform float edge_scale = 1.5;
uniform float near = 0.1;
uniform float far = 100.0;

// waves
uniform vec2 wave_strength = vec2(1.2, 1.3);
uniform vec2 wave_frequncy = vec2(10.0, 8.0);
uniform vec2 time_factor = vec2(1.0, 1.0);

uniform sampler2D depth_text : hint_depth_texture;
uniform sampler2D screen_text : hint_screen_texture;

float waves(vec2 pos, float time){
	float y_wave = wave_strength.y * sin(pos.y * wave_frequncy.y + time * time_factor.y);
	float x_wave = wave_strength.x * sin(pos.x * wave_frequncy.x + time * time_factor.x);
	return x_wave + y_wave;
}


void vertex(){
	VERTEX.y += waves(VERTEX.xy, TIME);
	
}

float rim(float depth){
	depth = 2.0 * depth - 1.0;
	return near * far / (far + depth * (near - far));
}

void fragment(){
	float time = TIME * speed * 0.4;
	// for normalmap
	vec2 uv_movement = UV;
	uv_movement.x += time;
	// get noise
	vec3 n1 = texture(noise1, uv_movement).rgb;
	uv_movement.x -= time * 0.2;
	vec3 n2 = texture(noise2, UV - time * 0.2).rgb;
	float sum = (n1.r + n2.r) - 1.0;
	// for reflections (add to aplha)
	vec2 displacement = vec2(sum * 0.02);
	// for edges:
	float z_depth = rim(texture(depth_text, SCREEN_UV).x);
	float z_pos = rim(FRAGCOORD.z);
	float diff = z_depth - z_pos;
	diff += displacement.x * 25.0;
	// get color and current screen
	vec4 col = mix(edge_color, color, step(edge_scale, diff));
	vec4 alpha = texture(screen_text, SCREEN_UV);
	// make sume only 3 different vaules:
	float fin = 0.0;
	if (sum > 0.0 && sum < 0.4) fin = 0.1;
	if (sum > 0.4 && sum < 0.8) fin = 0.0;
	if (sum > 0.8) fin = 1.0;
	// set color:
	
	ALBEDO = vec3(fin) + mix(alpha.rgb, col.rgb, col.a);
}