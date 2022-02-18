shader_type canvas_item;

uniform sampler2D palette;
uniform float shadow_amount = 0.005;

float shadow_depth(sampler2D tex, vec2 uv, vec2 look_distance, float current_height) {
	float sample = texture(tex, uv+look_distance).r;
	float shadow = min(0.0, current_height - sample);
	return shadow;
}

void fragment() {
	vec4 screen_sample = texture(SCREEN_TEXTURE, SCREEN_UV);
	float r = screen_sample.r;
	float shadow = shadow_depth(SCREEN_TEXTURE, SCREEN_UV, vec2(0.005), r);
	shadow += shadow_depth(SCREEN_TEXTURE, SCREEN_UV, vec2(-0.005), r);
	shadow /= 2.0;
	
	vec4 palette_sample = texture(palette, vec2(screen_sample.g)) * screen_sample.b;
	//palette_sample.rgb *= 1.0-shadow;
	COLOR = mix(palette_sample, vec4(vec3(0.0), 1.0), -shadow);
}
