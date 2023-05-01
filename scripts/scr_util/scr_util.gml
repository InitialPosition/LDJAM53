/// get a color to draw different ID mailboxes / mail with
function scr_util_get_mail_color(_box_id) {
	var _colors = [
		make_color_rgb(255, 255, 255),
		make_color_rgb(224, 123, 65),
		make_color_rgb(144, 224, 65),
		make_color_rgb(65, 224, 216),
		make_color_rgb(110, 65, 224),
		make_color_rgb(224, 65, 181),
		make_color_rgb(214, 85, 98),
		make_color_rgb(109, 63, 36),
		make_color_rgb(64, 99, 29),
	];
	
	return array_get(_colors, _box_id)
}

function scr_util_get_server_max_count() {
	return 9;
}
