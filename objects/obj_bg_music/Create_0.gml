if !audio_group_is_loaded(audiogroup_snd) {
	audio_group_load(audiogroup_snd);
}

if !audio_is_playing(mus_bg) {
	audio_play_sound(mus_bg, 1, true);
}

music_muted = false;
audio_group_set_gain(audiogroup_default, 1, 2000);
