function character_init() {
	globalvar CHARACTER, attempts, hunger;
	CHARACTER = {
		//properties: {
		//	walk_speed: 1.7,
		//	run_speed: 2.1,
		//	jump_height: 7,
		//	gravity_value: 0.5
		//},
		references: {
			current_player: -1,
			current_camera: -1,
			current_level: [-1,-1]
		}
	}
	attempts = 0;
	hunger = 0;
}

function character_set_player(_player) {
	if (instance_exists(_player)) {
		CHARACTER.references.current_player = _player;
	}
}

function character_set_camera(_camera) {
	CHARACTER.references.current_camera = _camera;
}

function character_update_level(_world_id,_level_id) {
	CHARACTER.references.current_level = [_world_id,_level_id];
}