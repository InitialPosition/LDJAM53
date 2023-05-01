function scr_mail_server_init() {
	active = false;
	hovering_letters = ds_list_create();
	
	mail_spawn_timer_min = 300;
	mail_spawn_timer_max = 480;
	
	occupied = [
		false,
		false,
		false,
		false,
		false,
		false,
		false,
		false
	];
	
	if !instance_exists(obj_game_manager) {
		instance_create_layer(0, 0, "Instances", obj_game_manager);
	}
	parent_id = 0;
	mailbox_color = c_white;
	
	drop_enabled = false;
	
	current_mail_count = 0;
	
	is_trash = false;
	
	spam_chance = 0.25;
}

function scr_mail_server_get_spawn_time() {
	return irandom_range(mail_spawn_timer_min, mail_spawn_timer_max);
}

function scr_mail_server_update() {
	if ds_exists(hovering_letters, ds_type_list) {
		ds_list_clear(hovering_letters);
	} else {
		hovering_letters = ds_list_create();
	}
	
	var _letter_count = instance_place_list(x, y, obj_mail, hovering_letters, false);
	var _i;
	var _current_letter;
	
	drop_enabled = false;
	
	if _letter_count > 0 {
		for (_i = 0; _i < _letter_count; _i++) {
			_current_letter = hovering_letters[| _i];
			if instance_exists(obj_mouse) {
				if _current_letter.target_id == parent_id && obj_mouse.last_mail == _current_letter {
					drop_enabled = true;
					break;
				}
			}
		}
	}
}

function scr_mail_server_set_data(_parent_id) {
	parent_id = _parent_id;
	mailbox_color = scr_util_get_mail_color(_parent_id);
}

function scr_mail_server_set_mail_data(_mail, _parent_id, _parent, _box_id, _occupied_direction) {
	_mail.parent_id = _parent_id;
	_mail.parent_server = _parent;
	_mail.target_id = _box_id;
	_mail.occupied_direction = _occupied_direction;
	
	// get draw color for mail
	_mail.mail_color = scr_util_get_mail_color(_box_id);
}

function scr_mail_server_spawn_mail() {
	if active {
		alarm[0] = scr_mail_server_get_spawn_time();
	}
	
	var _target_mail_server;
	// since current_mailbox_count holds the NEXT server ID, subtract 1
	var _mailbox_count = obj_game_manager.current_mailbox_count - 1;
	if _mailbox_count > 0 {
		_target_mail_server = irandom(_mailbox_count);
		while _target_mail_server == parent_id {
			_target_mail_server = irandom(_mailbox_count);
		}
	} else {
		exit;
	}
	
	current_mail_count++;
	if current_mail_count > 8 {
		scr_game_manager_game_over();
		exit;
	}
	var _new_mail = instance_create_layer(x + 16, y + 120, "Mail", obj_mail);
	
	// override for spam
	if obj_game_manager.spam_mails_enabled {
		if random(1) < spam_chance {
			_new_mail.is_spam = true;
		}
	}
	
	// determine where to throw the mail
	var _occupied_direction = 0;
	var _i;
	for (_i = 0; _i < 8;_i++) {
		if occupied[_i] == false {
			occupied[_i] = true;
			break;
		}
		_occupied_direction++;
	}
	
	audio_play_sound(snd_mail, 1, false);
	
	scr_mail_server_set_mail_data(_new_mail, parent_id, id, _target_mail_server, _occupied_direction);
	
	_new_mail.direction = 90 + (45 * _occupied_direction);
	_new_mail.speed = 25;
}

function scr_mail_server_draw() {
	// draw shadow
	draw_sprite_ext(spr_shadow, 0, x, y + sprite_height - 4, 8, 0.5, 0, 1, 0.3);
	draw_sprite_ext(spr_server, 0, x, y, 1, 1, 0, mailbox_color, 1);
	
	// draw load indicator
	draw_sprite(spr_load_indicator, current_mail_count, x, y);
	
	// draw sprite id
	draw_set_font(fnt_server);
	draw_set_halign(fa_center);
	draw_text_color(x + sprite_width / 2, y + sprite_height / 2 + 64, string(parent_id), mailbox_color, mailbox_color, mailbox_color, mailbox_color, 1);
	
	// draw drop indicator
	if drop_enabled {
		draw_sprite(spr_server_indicator, 0, x - 4, y - 4);
	}
}
