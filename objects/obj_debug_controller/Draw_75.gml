if debug_enabled {
	var _str = string(@"FPS: {0}
	REAL FPS: {1}
	ROOM: {2}
	POSITION: {3}, {4}
	VERSION: v{5}, r{6}
	BUILD: {7}",
	fps, fps_real, room_get_name(room), obj_player.x, obj_player.y,
	GM_version, GM_runtime_version, GM_build_date);
	draw_set_font(fnt_default);
	draw_set_color(c_white);
	draw_text(0,0,_str);
}