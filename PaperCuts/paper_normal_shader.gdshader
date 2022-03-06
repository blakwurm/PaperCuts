shader_type canvas_item;

uniform sampler2D encoded;



uniform sampler2D type_a;
uniform sampler2D type_b;
uniform sampler2D type_c;
uniform sampler2D type_d;
uniform sampler2D type_e;
uniform sampler2D type_f;
uniform sampler2D type_g;
uniform sampler2D type_h;
uniform sampler2D type_i;
uniform sampler2D type_j;
uniform sampler2D type_k;
uniform sampler2D type_l;
uniform bool as_normal = true;

const float material_count = 12.0;

vec2 random(vec2 uv) {
	return vec2(fract(sin(dot(uv.xy,
		vec2(12.9898,78.233))) * 43758.5453123));
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

float when_eq(int x, int y) {
  return float(1 - abs(sign(x - y)));
}

vec3 get_this_normal(float blue_channel, vec2 uv) {
	//uv = uv * vec2(1.0, -1.0);
	int ind = int(round(blue_channel*material_count));
	vec4 ret = vec4(0.5,0.5,1.0,1.0) * when_eq(ind, 0);
	ret += texture(type_a, uv) * when_eq(ind, 1);
	ret += texture(type_b, uv) * when_eq(ind, 2);
	ret += texture(type_c, uv) * when_eq(ind, 3);
	ret += texture(type_d, uv) * when_eq(ind, 4);
	ret += texture(type_e, uv) * when_eq(ind, 5);
	ret += texture(type_f, uv) * when_eq(ind, 6);
	ret += texture(type_g, uv) * when_eq(ind, 7);
	ret += texture(type_h, uv) * when_eq(ind, 8);
	ret += texture(type_i, uv) * when_eq(ind, 9);
	ret += texture(type_j, uv) * when_eq(ind, 10);
	ret += texture(type_k, uv) * when_eq(ind, 11);
	ret += texture(type_l, uv) * when_eq(ind, 12);
	ret.a = 1.0;
	return ret.rgb;
}

void fragment() {
	float screenratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec3 this_normal = get_this_normal(texture(encoded, UV).b, fract(SCREEN_UV*3.14*vec2(1, screenratio)));
	vec2 vor = voronoi(SCREEN_UV, 20.0, 10.0);
	if (as_normal) {
		COLOR = texture(TEXTURE, UV) * (vor.x + vor.y);
		NORMAL = this_normal;
	} else {
		COLOR.rgb = this_normal;
	}
	//NORMAL = texture(dirt_and_gravel, SCREEN_UV);
}