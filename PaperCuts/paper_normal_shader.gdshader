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

const float material_count = 12.0;

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
	NORMAL = get_this_normal(texture(encoded, UV).b, fract(SCREEN_UV*3.14));
	//NORMAL = texture(dirt_and_gravel, SCREEN_UV);
}