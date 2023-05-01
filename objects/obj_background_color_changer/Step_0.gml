/// @description 

current_hue += color_change_speed;
if current_hue > 255 {
	current_hue = 0;
}
current_color = make_color_hsv(current_hue, 40, 70);

layer_background_blend(bg_layer, current_color);