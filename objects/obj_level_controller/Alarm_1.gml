if obj_camera_controller.screen_value > 0 {
	if obj_camera_controller.screen_value == obj_camera_controller.screen_max {
		room_goto(target_room);
		obj_camera_controller.screen_value--;
	} else {
		obj_camera_controller.screen_value--;
	}
	alarm[1] = 1;
} else {
	is_transition = false;
}