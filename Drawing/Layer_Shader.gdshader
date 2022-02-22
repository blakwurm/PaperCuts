shader_type canvas_item;

uniform float height = 0.5;
uniform float palette_offset = 0.5;
uniform float brightness_add = 0.0;

void fragment() {
	float black_chan = texture(TEXTURE, UV).r;
	COLOR.a = round(black_chan);
	COLOR.r = height;
	COLOR.g = palette_offset;
	COLOR.b = brightness_add;
}