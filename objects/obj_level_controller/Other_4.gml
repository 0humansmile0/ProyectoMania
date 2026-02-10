switch (target_room) {
	case lvl_w1_area1: {
		audio_stop_all();
		audio_play_sound(mus_w1_area1,0,true);
	} break;
	
	case lvl_w1_area2: {
		audio_stop_all();
		audio_play_sound(mus_w1_area2,0,true);
	} break;
}