if obj_camera_controller.screen_value > 0 {
	if obj_camera_controller.screen_value < obj_camera_controller.screen_max {
		obj_camera_controller.screen_value++;
		alarm[0] = 1;
	} else {
		alarm[1] = 1;
	}
}