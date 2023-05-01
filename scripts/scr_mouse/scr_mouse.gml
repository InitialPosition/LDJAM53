function scr_mouse_init() {
	window_set_cursor(cr_none);

	last_mail = noone;
}

function scr_mouse_update() {	
	if last_mail != noone {
		if place_empty(x, y, last_mail) {
			last_mail.mouse_hovering = false;
			last_mail = noone;
		}
	} else {
		last_mail = instance_place(x, y, obj_mail);
		if last_mail != noone {
			last_mail.mouse_hovering = true;
		}
	}
	
	// update position
	x = window_mouse_get_x();
	y = window_mouse_get_y();
}

function scr_mouse_click_down() {
	with obj_mail {
		is_dragged = false;
	}
	
	last_mail = instance_place(x, y, obj_mail);
	if last_mail != noone {
		
		last_mail.drag_offset_x = x - last_mail.x;
		last_mail.drag_offset_y = y - last_mail.y;
		
		last_mail.is_dragged = true;
		
		scr_mail_set_depths(last_mail);
	}
}
