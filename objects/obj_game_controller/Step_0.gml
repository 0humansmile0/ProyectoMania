if global.time_start {
	global.time_ms += d(1);
	
	if global.time_ms >= 60 {
		global.time_ms -= 60;
		global.time_s++;
	}
	if global.time_s >= 60 {
		global.time_s = 0;
		global.time_m++;
	}
} else {
	if keyboard_check_pressed(vk_anykey) global.time_start = true;
}