shader_type spatial;

uniform vec4 color : source_color;
uniform vec4 color_2 : source_color;
uniform sampler2D noise1;

void fragment() {
	vec2 shifted_uv = vec2(UV.x + 0.01*TIME, UV.y - 0.05*TIME);
	float mix_noise = texture(noise1, shifted_uv).r;
	ALBEDO = mix(color, color_2, mix_noise).rgb;
}
