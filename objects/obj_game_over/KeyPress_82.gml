
if current_a_text > 0.5 {
	with obj_mail {
		instance_destroy();
	}
	
	with obj_mail_server {
		if variable_instance_exists(self, "hovering_letters") {
			if ds_exists(hovering_letters, ds_type_list) {
				ds_list_destroy(hovering_letters);
			}
		}
	}
	
	room_restart();
}
