#macro SOLID_INTERFACE [obj_solid,obj_beg,obj_exp]
//[layer_tilemap_get_id("Solid"), obj_solid]
#macro OBSTACLE_INTERFACE obj_alive
#macro point_max 128
//DONE: make double tap behaviour to "dash" (for older map compatibility)

function Initialize() {
	expected_fps = 60;
	hsp = 0;
	vsp = 0;
	hsp_final = 0;
	vsp_final = 0;
	hsp_f = 0;
	vsp_f = 0;
	grav = 0.3;
	
	x_start = x;
	y_start = y;
	hunger_start = hunger;
	greed_start = greed;

	mspd = 3;
	jspd = 9;

	moveL = 0;
	moveR = 0;
	moveJ = 0;
	moveD = 0;
	
	double_jump = 1;
	double_allowed = true;

	coyote_time = 1;
	coyote_time_max = 4;
	
	enum DASH_DIR {
		NONE,
		LEFT,
		RIGHT
	}
	dash_tap_frames = 11;
	dash_tap_timer = 0;
	dash_last_direction = DASH_DIR.NONE;
	dash_is_dashing = false;
	dash_move = 0;
	dash_duration = 16;
	dash_px = 32;
	
	layer_set_visible("Background",true)
	instance_deactivate_object(obj_beg);
	instance_deactivate_object(obj_bg_beg);
	instance_activate_object(obj_exp);
	character_set_player(PLAYERS.Explorer);
}

function Update() {
	switch(CHARACTER.references.current_player) {
		case PLAYERS.Begsalon: window_set_caption(string("tengo el {0}% de los diamantes, he muerto {1} veces", (greed/point_max)*100, attempts)); break;
		case PLAYERS.Explorer: window_set_caption(string("tengo el {0}% de los chocos, he fallado {1} veces", (hunger/point_max)*100, attempts)); break;
	}
}

function OnGround() {
	if (place_meeting(x,y+1,SOLID_INTERFACE)) {
		return true;
	} else return false;
}

function Keys() {
	moveL = keyboard_check(vk_left) || keyboard_check(ord("A"))
	moveR = keyboard_check(vk_right) || keyboard_check(ord("D"))
	moveJ = keyboard_check(vk_up) || keyboard_check(ord("W")) || keyboard_check(vk_space)
	moveJp = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_space)
	moveD = keyboard_check(vk_down) || keyboard_check(ord("S"))
	moveB = keyboard_check_pressed(vk_backspace)
	moveS = keyboard_check_pressed(ord("R"))
	moveU = keyboard_check(vk_shift);
}

function Moving() {
	mspd = 3;
	if CHARACTER.references.current_player == PLAYERS.Begsalon mspd = 3 + (moveU*1.5);
	hsp = ((moveR - moveL) * mspd);
	if moveD {
		vsp += grav;
	} else {
		if (vsp<10) vsp += grav;
	}
}

function Coyote() {
	if (coyote_time > 0) {
		coyote_time--;
	}
	
	if OnGround() {
		if CHARACTER.references.current_player == PLAYERS.Explorer {
			double_jump = 1;
			double_allowed = true;
		}
		jspd = 9;
		coyote_time = coyote_time_max;
	}
}

function Jumping() {
	//Jumping
	if moveJp and double_jump > 0 and double_allowed and !OnGround() and CHARACTER.references.current_player == PLAYERS.Explorer {
		coyote_time = coyote_time_max;
		double_allowed = false;
		double_jump--;
		jspd = 6;
	}
	
	if (moveJ > 0 && coyote_time > 0) {
		coyote_time = 0;
		vsp = moveJ * -jspd;
	}
	
	if (vsp < 0) && (!moveJ) {
		vsp = max(vsp, -jspd/4);
	}
	
	//Cancelling
	if moveD and !OnGround() {
		grav += 0.06;
	} else {
		grav = 0.3;
	}
}

function FuckFractions() {
	hsp_final = hsp + hsp_f;
	hsp_f = hsp_final - floor(abs(hsp_final))*sign(hsp_final);
	hsp_final -= hsp_f;
 
	vsp_final = vsp + vsp_f;
	vsp_f = vsp_final - floor(abs(vsp_final))*sign(vsp_final);
	vsp_final -= vsp_f;
}

function FinalMove() {
	if (place_meeting(x+hsp_final,y,SOLID_INTERFACE)) {
	    var inc = sign(hsp_final);
	    while (!place_meeting(x+inc,y,SOLID_INTERFACE)) x+= inc;
	    hsp_final = 0;
	    hsp = 0;
	}
 
	if (place_meeting(x,y+vsp_final,SOLID_INTERFACE)) {
	    var inc = sign(vsp_final);
	    while (!place_meeting(x,y+inc,SOLID_INTERFACE)) y+= inc;
	    vsp_final = 0;
	    vsp = 0;
	}
	
	//Final move
	x += d(hsp_final)
	y += d(vsp_final);
}

function DashMechanic() {
	if (dash_tap_timer > 0) dash_tap_timer--;
	if (dash_duration > 0) dash_duration--;
	
	if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D")) ) {
		if (dash_tap_timer > 0 && dash_last_direction == DASH_DIR.RIGHT) and (dash_duration == 0 && !place_meeting(x+dash_px+mspd,y,SOLID_INTERFACE)) {
			x+=dash_px;
			x=round(x/dash_px)*dash_px;
			dash_duration = 45;
		}
		
		dash_tap_timer = dash_tap_frames;
		dash_last_direction = DASH_DIR.RIGHT;
	}
	
	if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A")) ) {
		if (dash_tap_timer > 0 && dash_last_direction == DASH_DIR.LEFT) and (dash_duration == 0 && !place_meeting(x-dash_px+mspd,y,SOLID_INTERFACE)) {
			x-=dash_px;
			x=round(x/dash_px)*dash_px;
			dash_duration = 45;
		}
		
		dash_tap_timer = dash_tap_frames;
		dash_last_direction = DASH_DIR.LEFT;
	}
}

function ObstacleHandling() {
	if (place_meeting(x,y,OBSTACLE_INTERFACE)) or (moveB) or (y > room_height + 48)  {
		room_restart();
		attempts++;
		room_attempts++;
		hunger = hunger_start;
		greed = greed_start;
		Update();
		//DONE: play sound for death
	}
}

function SpriteHandling() {
	if (hsp_final != 0) {
		if (vsp_final == 0) {
			sprite_index = CHARACTER.sprites.walk;
		} else {
			sprite_index = CHARACTER.sprites.jump;
		}
		
		if hsp_final > 0 {
			image_xscale = 1;
		} else image_xscale = -1;
	} else {
		if (vsp_final == 0) {
			sprite_index = CHARACTER.sprites.stand;
		} else {
			sprite_index = CHARACTER.sprites.front;
		}
	}
	
	image_speed = d(mspd/3);
	
	depth = -9999999;
}

function Switch() {
	if moveS {
		switch (CHARACTER.references.current_player) {
			case PLAYERS.Explorer: {
				if !place_meeting(x,y,obj_bg_exp) break;
				layer_set_visible("Background",false)
				instance_deactivate_object(obj_exp);
				instance_deactivate_object(obj_bg_exp);
				instance_activate_object(obj_beg);
				instance_activate_object(obj_bg_beg);
				mask_index = spr_beg_mask;
				character_set_player(PLAYERS.Begsalon); break;
			}
		
			case PLAYERS.Begsalon: {
				if !place_meeting(x,y,obj_bg_beg) break;
				layer_set_visible("Background",true)
				instance_deactivate_object(obj_beg);
				instance_deactivate_object(obj_bg_beg);
				instance_activate_object(obj_exp);
				instance_activate_object(obj_bg_exp);
				mask_index = spr_explorer_mask;
				character_set_player(PLAYERS.Explorer); break;
			}
		}
		Update();
	}
	
}

Initialize();
Update();