shader_type canvas_item;

uniform float height = 0.5;
uniform float palette_offset = 0.5;

void fragment() {
	float black_chan = texture(TEXTURE, UV).r;
	COLOR.a = black_chan;
	COLOR.r = height;
	COLOR.g = palette_offset;
}