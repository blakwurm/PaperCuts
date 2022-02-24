shader_type canvas_item;

uniform sampler2D black_granite;
uniform sampler2D buffed_marble;
uniform sampler2D dirt_and_gravel;
uniform sampler2D fine_gray_gravel;
uniform sampler2D flower_pattern;
uniform sampler2D golden_snakeskin;
uniform sampler2D gray_swirl;
uniform sampler2D green_marble;
uniform sampler2D jade_cloth;
uniform sampler2D jute_cocomat;
uniform sampler2D spots_pxr;
uniform sampler2D tan_marble;

const float material_count = 12.0;

float when_eq(int x, int y) {
  return float(1 - abs(sign(x - y)));
}

vec4 get_this_normal(float blue_channel, vec2 uv) {
	//uv = uv * vec2(1.0, -1.0);
	int ind = int(round(blue_channel*material_count));
	vec4 ret = vec4(0.5,0.5,1.0,1.0) * when_eq(ind, 0);
	ret += texture(black_granite, uv) * when_eq(ind, 1);
	ret += texture(buffed_marble, uv) * when_eq(ind, 2);
	ret += texture(dirt_and_gravel, uv) * when_eq(ind, 3);
	ret += texture(fine_gray_gravel, uv) * when_eq(ind, 4);
	ret += texture(flower_pattern, uv) * when_eq(ind, 5);
	ret += texture(golden_snakeskin, uv) * when_eq(ind, 6);
	ret += texture(gray_swirl, uv) * when_eq(ind, 7);
	ret += texture(green_marble, uv) * when_eq(ind, 8);
	ret += texture(jade_cloth, uv) * when_eq(ind, 9);
	ret += texture(jute_cocomat, uv) * when_eq(ind, 10);
	ret += texture(spots_pxr, uv) * when_eq(ind, 11);
	ret += texture(tan_marble, uv) * when_eq(ind, 12);
	ret.a = 1.0;
	return ret;
}

void fragment() {
	COLOR = get_this_normal(texture(TEXTURE, UV).b, UV);
	//COLOR = texture(dirt_and_gravel, UV);
}