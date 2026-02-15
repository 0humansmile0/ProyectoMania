#macro SOLID_INTERFACE [layer_tilemap_get_id("Solid"), obj_solid]
#macro OBSTACLE_INTERFACE obj_alive
#macro hunger_max 128
//TODO: make double tap behaviour to "dash" (for older map compatibility)

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

	mspd = 3;
	jspd = 9;

	moveL = 0;
	moveR = 0;
	moveJ = 0;
	moveD = 0;

	coyote_time = 1;
	coyote_time_max = 5;
	
	enum DASH_DIR {
		NONE,
		LEFT,
		RIGHT
	}
	dash_tap_frames = 12;
	dash_tap_timer = 0;
	dash_last_direction = DASH_DIR.NONE;
	dash_is_dashing = false;
	dash_move = 0;
	dash_duration = 16;
}

function Update() {
	window_set_caption(string("tengo el {0}% de los chocos, he fallado {1} veces", (hunger/hunger_max)*100, attempts));
}

function OnGround() {
	if (place_meeting(x,y+1,SOLID_INTERFACE)) {
		return true;
	} else return false;
}

function Keys() {
	moveL = keyboard_check(vk_left)
	moveR = keyboard_check(vk_right)
	moveJ = keyboard_check(vk_up)
	moveD = keyboard_check(vk_down)
	moveB = keyboard_check_pressed(ord("R"));
}

function Moving() {
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
		coyote_time = coyote_time_max;
	}
}

function Jumping() {
	//Jumping
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
	
	if (keyboard_check_pressed(vk_right)) {
		if (dash_tap_timer > 0 && dash_last_direction == DASH_DIR.RIGHT) and (dash_duration == 0 && !place_meeting(x+16+mspd,y,SOLID_INTERFACE)) {
			x+=16;
			x=round(x/16)*16;
			dash_duration = 45;
		}
		
		dash_tap_timer = dash_tap_frames;
		dash_last_direction = DASH_DIR.RIGHT;
	}
	
	if (keyboard_check_pressed(vk_left)) {
		if (dash_tap_timer > 0 && dash_last_direction == DASH_DIR.LEFT) and (dash_duration == 0 && !place_meeting(x-16+mspd,y,SOLID_INTERFACE)) {
			x-=16;
			x=round(x/16)*16;
			dash_duration = 45;
		}
		
		dash_tap_timer = dash_tap_frames;
		dash_last_direction = DASH_DIR.LEFT;
	}
}

function ObstacleHandling() {
	if (place_meeting(x,y,OBSTACLE_INTERFACE)) or (moveB) or (y > room_height + 48)  {
		attempts++;
		x = x_start;
		y = y_start;
		hunger = hunger_start;
		with obj_choco {
			visible = true;
		}
		audio_play_sound(snd_lose,0,false);
		Update();
		//DONE: play sound for death
	}
}

function SpriteHandling() {
	if (hsp_final != 0) {
		if (vsp_final == 0) {
			sprite_index = spr_explorer_walk;
		} else {
			sprite_index = spr_explorer_jump;
		}
		
		if hsp_final > 0 {
			image_xscale = 1;
		} else image_xscale = -1;
	} else {
		if (vsp_final == 0) {
			sprite_index = spr_explorer_stand;
		} else {
			sprite_index = spr_explorer_jump;
		}
	}
	
	image_speed = d(1);
	
	depth = -9999999;
}

Initialize();
Update();