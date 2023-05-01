/// @description 

if last_mail != noone {
	last_mail.is_dragged = false;
	last_mail.mouse_hovering = false;
	
	var _mail_sent = false;
	
	with last_mail {
		var _collision_list = ds_list_create()
		var _found_server_count = instance_place_list(x, y, obj_mail_server, _collision_list, false);
		var _server_to_check;
		var _i;
		
		if _found_server_count > 0 {
			for (_i = 0; _i < _found_server_count; _i++) {
				_server_to_check = _collision_list[| _i];
				
				if _server_to_check.drop_enabled {
					ds_list_destroy(_collision_list);
					scr_mail_send(self, _server_to_check);
					break;
				}
			}
		}
		
		ds_list_destroy(_collision_list);
	}
	
	if instance_exists(last_mail) {
		last_mail.x = clamp(last_mail.x, 0, room_width - last_mail.sprite_width);
		last_mail.y = clamp(last_mail.y, 0, room_height - last_mail.sprite_height);
	}
	
	last_mail = noone;
}
