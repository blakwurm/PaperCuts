shader_type canvas_item;

uniform sampler2D palette;
uniform float shadow_amount = 0.0025;
uniform int shadow_passes = 10;

float shadow_depth(sampler2D tex, vec2 uv, vec2 look_distance, float current_height) {
	vec2 dist_fract = look_distance / float(shadow_passes);
	vec2 current_look = dist_fract;
	float shadow = 0.0;
	for (int i = 0; i < shadow_passes; i++) {
		float sample = textureLod(tex, uv+current_look, 0.8).r;
		shadow = min(0.0, current_height - sample) / float(shadow_passes-i);
		current_look += dist_fract;
	}
	return shadow;
}

void fragment() {
	vec4 screen_sample = texture(SCREEN_TEXTURE, SCREEN_UV);
	float r = screen_sample.r;
	float shadow = shadow_depth(SCREEN_TEXTURE, SCREEN_UV, vec2(shadow_amount, 0), r);
	shadow += shadow_depth(SCREEN_TEXTURE, SCREEN_UV, vec2(0, shadow_amount), r);
	shadow += shadow_depth(SCREEN_TEXTURE, SCREEN_UV, vec2(-shadow_amount, 0), r);
	shadow += shadow_depth(SCREEN_TEXTURE, SCREEN_UV, vec2(0, -shadow_amount), r);
	shadow /= 4.0;
	
	vec4 palette_sample = texture(palette, vec2(screen_sample.g)) * screen_sample.b;
	//palette_sample.rgb *= 1.0-shadow;
	COLOR = mix(palette_sample, vec4(vec3(0.0), 1.0), -shadow);
}
