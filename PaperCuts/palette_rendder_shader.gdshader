shader_type canvas_item;

uniform sampler2D palette;
uniform float shadow_amount = 0.005;
uniform int shadow_passes = 10;
uniform sampler2D normals;

float shadow_depth(sampler2D tex, vec2 uv, vec2 look_distance, float current_height) {
	vec2 dist_fract = look_distance / float(shadow_passes);
	vec2 current_look = dist_fract;
	float shadow = 0.0;
	for (int i = 0; i < shadow_passes; i++) {
		float sample = textureLod(tex, uv+dist_fract*float(i), 4.0).r;
		shadow += min(0.0, (current_height - sample)/float(i)*0.5);
		current_look += dist_fract;
	}
	return shadow;
}

float new_shadow_depth(sampler2D tex, vec2 uv, vec2 look_distance, float current_height) {
	float sample = texture(tex, uv).r;
	float shadow = min(0.0, current_height - sample);
	return shadow;
}

void fragment() {
	vec4 screen_sample = texture(TEXTURE, UV);
	float r = screen_sample.r;
	float shadow = shadow_depth(TEXTURE, UV, vec2(shadow_amount, 0), r);
	shadow += shadow_depth(TEXTURE, UV, vec2(0, shadow_amount), r);
	shadow += shadow_depth(TEXTURE, UV, vec2(-shadow_amount, 0), r);
	shadow += shadow_depth(TEXTURE, UV, vec2(0, -shadow_amount), r);
	shadow += shadow_depth(TEXTURE, UV, vec2(shadow_amount, shadow_amount), r);
	shadow += shadow_depth(TEXTURE, UV, vec2(-shadow_amount, -shadow_amount), r);
	shadow += shadow_depth(TEXTURE, UV, vec2(shadow_amount, -shadow_amount), r);
	shadow += shadow_depth(TEXTURE, UV, vec2(-shadow_amount, shadow_amount), r);
	shadow /= 8.0;
	
	vec4 palette_sample = (texture(palette, vec2(screen_sample.g))); // * (1.0+15.0*pow(100000.0, screen_sample.b - 1.0)) ) ;
	//palette_sample.rgb *= 1.0-shadow;
	COLOR = mix(palette_sample, vec4(vec3(0.0), 1.0), -shadow);
	COLOR.a = screen_sample.a;
}
