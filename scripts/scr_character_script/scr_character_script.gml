function character_init() {
	globalvar CHARACTER, attempts, hunger, greed, room_attempts;
	
	enum PLAYERS {
		Explorer,
		Begsalon
	}
	
	CHARACTER = {
		//properties: {
		//	walk_speed: 1.7,
		//	run_speed: 2.1,
		//	jump_height: 7,
		//	gravity_value: 0.5
		//},
		references: {
			current_player: PLAYERS.Explorer,
			current_camera: -1,
			current_level: [-1,-1]
		},
		
		sprites: {
			walk: spr_explorer_walk,
			stand: spr_explorer_stand,
			jump: spr_explorer_jump,
			front: spr_explorer_front
		}
	}
	attempts = 0;
	hunger = 0;
	greed = 0;
	room_attempts = 0;
}

function character_set_sprites(_walk,_stand,_jump,_front) {
	CHARACTER.sprites.walk = _walk;
	CHARACTER.sprites.stand = _stand;
	CHARACTER.sprites.jump = _jump;
	CHARACTER.sprites.front = _front;
}

function character_set_player(_player) {
	CHARACTER.references.current_player = _player;
	switch (_player) {
		case PLAYERS.Begsalon: character_set_sprites(spr_beg_walk,spr_beg_stand,spr_beg_jump,spr_beg_front); break;
		case PLAYERS.Explorer: character_set_sprites(spr_explorer_walk,spr_explorer_stand,spr_explorer_jump,spr_explorer_front); break;
	}
}

function character_set_camera(_camera) {
	CHARACTER.references.current_camera = _camera;
}

function character_update_level(_world_id,_level_id) {
	CHARACTER.references.current_level = [_world_id,_level_id];
}