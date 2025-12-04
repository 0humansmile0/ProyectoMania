function game_init() {}

function transition_room(_room_id) {
	with obj_level_controller {
		target_room = _room_id;
		alarm[2] = 1;
	}
}