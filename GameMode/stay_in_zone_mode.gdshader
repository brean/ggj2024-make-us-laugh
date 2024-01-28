shader_type spatial;
render_mode diffuse_toon, cull_disabled;

uniform vec3 area_color : source_color;
uniform vec3 area_color_2 : source_color;

void fragment() {
	float vertex_y = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).y;
	if(vertex_y > 4.0){
		ALPHA = 0.0;
	}
	else{
		ALPHA = (1.0 + sin(5.0*vertex_y + 2.0*TIME))/2.0;
		ALBEDO = mix(area_color, area_color_2, sin(1.1*TIME));
	}
}
