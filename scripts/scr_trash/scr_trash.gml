function scr_trash_init() {
	parent_id = scr_util_get_server_max_count() + 1;
	
	drop_enabled = false;
	
	y_orig = y;
	y_offset_smooth = y + 150;
	
	y = y_offset_smooth;
	
	is_trash = true;
}

function scr_trash_update() {
	drop_enabled = instance_place(x, y, obj_mail);
	
	if obj_game_manager.trash_enabled {
		if y_offset_smooth != y_orig {
			y_offset_smooth += (y_orig - y_offset_smooth) / 15;
		}
	}
	
	y = y_offset_smooth;
}

function scr_trash_draw() {
	draw_sprite_ext(spr_shadow, 0, x + 4, y + 90, 5.5, 1, 0, c_white, 0.3);
	draw_self();
	
	if drop_enabled {
		draw_sprite(spr_trashcan_selector, 0, x, y);
	}
}
