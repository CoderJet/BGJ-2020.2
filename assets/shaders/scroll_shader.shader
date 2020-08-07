shader_type canvas_item;
render_mode blend_mix;

uniform bool invert_x : bool;
uniform bool invert_y : bool;
uniform float x_scroll_speed : hint_range(0.01, 10.0, 0.01);
uniform float y_scroll_speed : hint_range(0.01, 10.0, 0.01);

void fragment() {
	vec2 uv = UV;
	uv.x += TIME * x_scroll_speed * (invert_x ? -1.0 : 1.0);
	uv.y += TIME * y_scroll_speed * (invert_y ? -1.0 : 1.0);
	uv.x = mod(uv.x, 1.0);
	uv.y = mod(uv.y, 1.0);
	COLOR = texture(TEXTURE, uv);
}