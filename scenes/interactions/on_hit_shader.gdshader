shader_type canvas_item;
uniform sampler2D existing_screen_texture: hint_screen_texture, filter_linear_mipmap;
uniform bool is_active;

void fragment(){
	if (is_active){
		COLOR.rgb = 1.0 - COLOR.rgb;
	}
}