if debug_enabled {
	with (obj_alive) {
		draw_sprite_ext(mask_index,image_index,x,y,1,1,0,c_white,0.5);
	}
	with (obj_player) {
		draw_sprite_ext(mask_index,image_index,x,y,1,1,0,c_white,0.5);
	}
	with (obj_solid) {
		draw_sprite_ext(mask_index,image_index,x,y,1,1,0,c_white,0.5);
	}
}