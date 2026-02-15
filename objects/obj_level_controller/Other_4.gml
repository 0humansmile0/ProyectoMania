switch (target_room) {
	case lvl_w1_area1: {
		audio_stop_all();
		audio_play_sound(mus_w1_area1,0,true);
	} break;
	
	case lvl_w1_area2: {
		audio_stop_all();
		audio_play_sound(mus_w1_area2,0,true);
	} break;
	
	case mn_0: {
		audio_stop_all();
		audio_play_sound(mus_mania,0,true);
		audio_sound_gain(mus_mania,0);
		audio_sound_gain(mus_mania,0.75,7777);
	} break;
}