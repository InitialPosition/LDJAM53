function scr_game_manager_init() {
	randomize();
	
	current_mailbox_count = 1;		// the tutorial server is also a server
	strikes = 0;
	
	points = 0;
	current_level = 0;
	level_points = -100;
	points_display = 0;
	
	gui_draw_offset = 120;
	gui_draw_offset_smoothed = 120;
	
	spam_mails_enabled = false;
	attachment_mails_enabled = false;
	
	trash_enabled = false;
	
	fade_tutorial = false;
	current_tutorial_alpha = 1
	tutorial_sprite = layer_sprite_create("Assets_1", 256, 64, spr_tutorial);
}

function scr_game_manager_game_over() {
	audio_play_sound(snd_fail, 1, false);
	
	gui_draw_offset = 120;
	
	with obj_trashcan {
		y_orig = y_orig + 150;
	}
	
	with obj_mail_server {
		alarm[0] = -1;
		active = false;
	}
	
	with obj_mouse {
		instance_destroy();
	}
	
	instance_create_layer(0, 0, "GameOver", obj_game_over);
}

function scr_game_manager_add_points(_amount) {
	with obj_game_manager {
		points += _amount;
		level_points += _amount;
		
		switch current_level {
			case 0:
				if level_points >= 500 {
					level_points -= 500;
					current_level++;
					scr_game_manager_spawn_new_server();
					audio_play_sound(snd_new_level, 1, false);
				}
				break;
			case 1:
				if level_points >= 1000 {
					level_points -= 1000;
					current_level++;
					scr_game_manager_spawn_new_server();
					audio_play_sound(snd_new_level, 1, false);
				}
				break;
			case 2:
				if level_points >= 1500 {
					level_points -= 1500;
					current_level++;
					scr_game_manager_spawn_new_server();
					scr_game_manager_enable_spam();
					audio_play_sound(snd_new_level, 1, false);
				}
				break;
			case 3:
				if level_points >= 2000 {
					level_points -= 2000;
					current_level++;
					scr_game_manager_spawn_new_server();
					audio_play_sound(snd_new_level, 1, false);
				}
				break;
			case 4:
				if level_points >= 2000 {
					level_points -= 2000;
					current_level++;
					scr_game_manager_spawn_new_server();
					audio_play_sound(snd_new_level, 1, false);
				}
				break;
			case 5:
				if level_points >= 3000 {
					level_points -= 3000;
					current_level++;
					scr_game_manager_spawn_new_server();
					audio_play_sound(snd_new_level, 1, false);
				}
				break;
			case 6:
				if level_points >= 3000 {
					level_points -= 3000;
					current_level++;
					scr_game_manager_spawn_new_server();
					audio_play_sound(snd_new_level, 1, false);
				}
				break;
		}
	}
}

function scr_game_manager_update() {
	if points_display != points {
		points_display += (points - points_display) / 5;
	}
	
	if gui_draw_offset != gui_draw_offset_smoothed {
		gui_draw_offset_smoothed += (gui_draw_offset - gui_draw_offset_smoothed) / 15;
	}
	
	if fade_tutorial {
		current_tutorial_alpha -= 0.01;
		if current_tutorial_alpha <= 0 {
			current_tutorial_alpha = 0;
			fade_tutorial = false;
		}
		layer_sprite_alpha(tutorial_sprite, current_tutorial_alpha);
	}
}

function scr_game_manager_enable_spam() {
	spam_mails_enabled = true;
	trash_enabled = true;
}

function scr_game_manager_spawn_new_server() {
	var _new_server = instance_create_layer(0, 0, "Instances", obj_mail_server);
	
	with _new_server {
		x = irandom_range(64, room_width - sprite_width - 64);
		y = irandom_range(64, room_height - sprite_height - 96);
		
		var _attempt_counter = 0;
		while !place_empty(x, y, obj_mail_server) && _attempt_counter < 32 {
			x = irandom_range(64, room_width - sprite_width - 64);
			y = irandom_range(64, room_height - sprite_height - 96);
		}
		
		// if placing failed, try again, allowing inoptimal space
		if _attempt_counter == 32 {
			show_debug_message("New server triggered placement failsafe");
			_attempt_counter = 0;
			while !place_empty(x, y, obj_mail_server) && _attempt_counter < 32 {
				x = irandom_range(0, room_width - sprite_width);
				y = irandom_range(64, room_height - sprite_height - 32);
			}
		}
		
		// if that fails as well, give up
		if _attempt_counter == 32 {
			show_debug_message("Holy moly");
			x = irandom_range(64, room_width - sprite_width - 64);
			y = irandom_range(64, room_height - sprite_height - 96);
		}
	}
	
	scr_game_manager_update_server_data(_new_server, current_mailbox_count);
	current_mailbox_count++;
	
	_new_server.active = true;
	with _new_server {
		alarm[0] = scr_mail_server_get_spawn_time();
	}
}

function scr_game_manager_add_strike() {
	strikes++;
	if strikes > 2 {
		scr_game_manager_game_over();
	}
}

function scr_game_manager_update_server_data(_server, _id) {
	_server.parent_id = _id;
	_server.mailbox_color = scr_util_get_mail_color(_id);
}

function scr_game_manager_draw() {
	draw_sprite(spr_strike_indicator, strikes, 20, 20 - gui_draw_offset_smoothed);
	
	draw_set_font(fnt_gui);
	draw_set_halign(fa_right);
	draw_text(room_width - 20, 20 - gui_draw_offset_smoothed , "SCORE " + string(round(points_display)));
}
