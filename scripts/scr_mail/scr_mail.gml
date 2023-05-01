function scr_mail_init() {
	// define variables
	mouse_hovering = false;
	
	is_dragged = false;
	drag_offset_x = 0;
	drag_offset_y = 0;
	
	mail_color = c_white;
	parent_id = 0;
	target_id = 0;
	
	is_spam = false;
	has_attachment = false;
	
	occupied_direction = 0;
}

function scr_mail_update() {	
	// move to mouse if currently clicked
	if is_dragged && instance_exists(obj_mouse) {
		x = obj_mouse.x - drag_offset_x;
		y = obj_mouse.y - drag_offset_y;
	}
	
	if speed > 0 {
		speed /= 1.2;
	}
	if speed < 0.001 {
		speed = 0;
	}
}

function scr_mail_draw() {
	draw_set_alpha(0.5);
	draw_line_width_color(x + sprite_width / 2, y + sprite_height / 2, parent_server.x + parent_server.sprite_width / 2, parent_server.y + parent_server.sprite_height / 2, 3, c_white, c_white);
	draw_set_alpha(1);
	// draw shadow
//	draw_sprite_ext(spr_shadow, 0, x, y + sprite_height - 4, 6, 0.3, 0, 1, 0.3);

	draw_sprite_ext(spr_mail, 0, x, y, 1, 1, 0, mail_color, 1);
	
	if is_spam {
		draw_sprite(spr_spam_mail, 0, x, y);
	}
	
	draw_set_font(fnt_server);
	draw_set_halign(fa_center);
	draw_text_color(x + 14, y + 20, string(target_id), mail_color, mail_color, mail_color, mail_color, 1);
	
	if mouse_hovering {
		draw_sprite(spr_mail_selector, 0, x - 4, y - 4);
	}
}

function scr_mail_set_depths(_active_mail) {
	var _i;
	var _mail_count = instance_number(obj_mail);
	var _current_mail;
	var _orig_depth = layer_get_depth("Mail");
	
	for (_i = 0; _i < _mail_count; _i++) {
		_current_mail = instance_find(obj_mail, _i);
		_current_mail.depth = _orig_depth;
	}
	
	// render clicked mail in front of all other mail
	_active_mail.depth = _orig_depth - 1;
}

function scr_mail_send(_target_letter, _override_server = noone) {
	if _target_letter.parent_server != noone {
		if !_target_letter.is_spam {
			if !_override_server.is_trash {
				scr_game_manager_add_points(100);
				audio_play_sound(choose(snd_deliver_1, snd_deliver_2, snd_deliver_3, snd_deliver_5), 1, false);
			} else {
				with obj_game_manager {
					scr_game_manager_add_strike();
				}
				audio_play_sound(snd_error, 1, false);
			}
		} else {
			if !_override_server.is_trash {
				with obj_game_manager {
					scr_game_manager_add_strike();
				}
				audio_play_sound(snd_error, 1, false);
			} else {
				scr_game_manager_add_points(150);
				audio_play_sound(choose(snd_deliver_1, snd_deliver_2, snd_deliver_3, snd_deliver_5), 1, false);
			}
		}
		
		_target_letter.parent_server.current_mail_count--;
		_target_letter.parent_server.occupied[_target_letter.occupied_direction] = false;
		if _target_letter.parent_server.current_mail_count < 0 {
			with _target_letter.parent_server {
				current_mail_count = 0;
				obj_game_manager.points -= 100;
				active = true;
				obj_game_manager.gui_draw_offset = 0;
				alarm[0] = scr_mail_server_get_spawn_time();
				with obj_game_manager {
					scr_game_manager_spawn_new_server();
					fade_tutorial = true;
				}
				
				audio_play_sound(snd_new_game, 1, false);
			}
		}
	}
	
	with _target_letter {
		instance_destroy();
	}
}
