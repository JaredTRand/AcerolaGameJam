shader_type sky;

uniform vec3 skyColor : source_color;
uniform vec3 horizonColor : source_color;

void sky() {
	float col = clamp(EYEDIR.y / .05, -.1, .75);
	vec3 finalColor = mix(horizonColor, skyColor, col);
	COLOR = finalColor;
}
