shader_type canvas_item;

uniform sampler2D palette;
uniform float shadow_amount = 0.005;
uniform int shadow_passes = 10;
uniform sampler2D normals;
uniform float vor_time_factor = 0.01;
uniform float island_time_factor = 0.001;

uniform sampler2D noise_1;


float when_eq(int x, int y) {
  return float(1 - abs(sign(x - y)));
}

float when_eq_f(float x, float y) {
  return 1.0 - abs(sign(x - y));
}

vec2 random(vec2 uv) {
	return vec2(fract(sin(dot(uv.xy,
		vec2(12.9898,78.233))) * (43758.5453123+TIME*vor_time_factor)));
}
vec2 voronoi(vec2 uv, float columns, float rows) {
	
	vec2 index_uv = floor(vec2(uv.x * columns, uv.y * rows));
	vec2 fract_uv = fract(vec2(uv.x * columns, uv.y * rows));
	
	float minimum_dist = 1.0;  
	vec2 minimum_point;
	

	for (int y= -1; y <= 1; y++) {
		for (int x= -1; x <= 1; x++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 point = random(index_uv + neighbor);

			vec2 diff = neighbor + point - fract_uv;
			float dist = length(diff);
			
			if(dist < minimum_dist) {
				minimum_dist = dist;
				minimum_point = point;
			}
		}
	}
	return minimum_point;
}

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

float bandy(float thing, int bands) {
	float bann = float(bands);
	float nt = round(thing * bann);
	return nt/bann;
}

const vec2 upvec = vec2(0,1);
const vec2 downvec = vec2(0, -1);
const vec2 leftvec = vec2(1, 0);
const vec2 rightvec = vec2(-1, 0);

float do_island_smooth(vec2 uv, float time, float strength) {
	float up = texture(noise_1, fract(0.4*uv+(upvec*time*0.001))).r;
	float down = texture(noise_1, fract(0.4*uv+(downvec*time*0.001))).r;
	float left = texture(noise_1, fract(0.4*uv+(leftvec*time*0.001))).r;
	float right = texture(noise_1, fract(0.4*uv+(rightvec*time*0.001))).r;
	return strength * up * down * left * right;
}

float do_island_banding(vec2 uv, float time, int bands, float strength) {
	float up = texture(noise_1, fract(0.4*uv+(upvec*time))).r;
	float down = texture(noise_1, fract(0.4*uv+(downvec*time))).r;
	float left = texture(noise_1, fract(0.4*uv+(leftvec*time))).r;
	float right = texture(noise_1, fract(0.4*uv+(rightvec*time))).r;
	return bandy(strength * up * down * left * right, bands);
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
	float slowtime = TIME*island_time_factor;
	float effectstrength = 10.0;
	vec2 vor1 = voronoi(fract(SCREEN_UV), 10.0, 10.0);
	vec2 vor2 = voronoi(fract(SCREEN_UV), 20, 20);
	vec2 vor3 = voronoi(fract((SCREEN_UV)), 40, 40);
	float n1 = do_island_smooth(SCREEN_UV*0.1, slowtime, effectstrength);
	float n2 = do_island_smooth(SCREEN_UV*0.5, slowtime, effectstrength);
	float n3 = do_island_smooth(fract(SCREEN_UV), slowtime, effectstrength);
	
	int factor = int(ceil(screen_sample.b * 9.0));
	
	float highlighter = (when_eq(factor, 0)*1.0)
	+(when_eq(factor, 1)*((vor1.r*0.4)+0.7))
	+(when_eq(factor, 2)*((vor2.r*0.4)+0.7))
	+(when_eq(factor, 3)*((vor3.r*0.4)+0.7))
	+(when_eq(factor, 4)*((1.0-n1*0.1)))
	+(when_eq(factor, 5)*((1.0-n2*0.1)))
	+(when_eq(factor, 6)*((1.0-n3*0.1)))
	+(when_eq(factor, 7)*(1.0-(do_island_banding(fract(SCREEN_UV*0.1), slowtime, 10, 8.0))*0.4))
	+(when_eq(factor, 8)*(1.0-(do_island_banding(fract(SCREEN_UV*0.5), slowtime, 5, 8.0))*0.4))
	+(when_eq(factor, 9)*(1.0-(do_island_banding(fract(SCREEN_UV), slowtime, 3, 8.0))*0.4))
	;
	
	vec4 palette_sample = (texture(palette, vec2(screen_sample.g)) * highlighter); // * (1.0+15.0*pow(100000.0, screen_sample.b - 1.0)) ) ;
	//palette_sample.rgb *= 1.0-shadow;
	COLOR = mix(palette_sample, vec4(vec3(0.0), 1.0), -shadow);
	COLOR.a = screen_sample.a;
}
