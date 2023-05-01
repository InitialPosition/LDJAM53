

caption = "GAME OVER!";
text = "Final Score: " + string(obj_game_manager.points);

audio_group_set_gain(audiogroup_default, 0, 500);

current_a_rect = 0;
current_a_text = 0;

a_speed = 0.01;
fading_phase = 0;
