globalvar CONTROLLERS_ACTIVE;
CONTROLLERS_ACTIVE = {
	cam_control: instance_create_depth(0,0,0,obj_camera_controller),
	level_control: instance_create_depth(0,0,0,obj_level_controller),
	game_control: instance_create_depth(0,0,0,obj_game_controller),
	main_control: id
	//todo add more
}

debug_enabled = false;

room_goto_next();