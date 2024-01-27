shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    // Calculate the normalized Y coordinate
    float normalized_y = (FRAGCOORD.y / TEXTURE_SIZE.y);

    // Set alpha based on Y coordinate (top half is transparent)
    COLOR.a = smoothstep(0.5, 0.51, normalized_y);
}
//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
