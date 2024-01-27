shader_type spatial;
render_mode diffuse_toon;

uniform sampler2D noise1;
uniform vec3 color : source_color;

void fragment() {
	vec2 move_uv = UV + 0.6 * TIME;
	float col = texture(noise1, move_uv).r;

	ALBEDO = col * color;
}
