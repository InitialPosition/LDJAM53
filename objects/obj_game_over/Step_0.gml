
if fading_phase == 0 {
	// fading up rectangle
	current_a_rect += a_speed;
	
	if current_a_rect >= 0.7 {
		current_a_rect = 0.7;
		fading_phase = 1;
	}
}
if fading_phase == 1 {
	current_a_text += a_speed;
	
	if current_a_text >= 1 {
		current_a_text = 1;
		fading_phase = 2;
	}
}
