/// @description  mute / unmute music

if music_muted {
	audio_group_set_gain(audiogroup_default, 1, 2000);
} else {
	audio_group_set_gain(audiogroup_default, 0, 2000);
}

music_muted = !music_muted;
