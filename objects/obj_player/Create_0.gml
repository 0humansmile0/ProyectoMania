#macro SOLID_INTERFACE [layer_tilemap_get_id("Solid"), obj_solid]
#macro OBSTACLE_INTERFACE obj_alive
character_init()

//lhc_activate();

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
	
	attempts = 0;
	
	//initial_pos_x = x;
	//initial_pos_y = y;

	mspd = 3;
	jspd = 9;

	moveL = 0;
	moveR = 0;
	moveJ = 0;

	coyote_time = 1;
	coyote_time_max = 4;
	
	//gravity_direction = 270;
	//d_gravity = grav;
}

// Add collision with Interface ISolid.
//lhc_add(SOLID_INTERFACE, function() {
//    // Check for horizontal collision.
//    if (lhc_collision_horizontal()) {
//        // Stop further x-axis movement this step...
//        lhc_stop_x();
//        // AND stop our x velocity.
//        hsp = 0;
//		hsp_final = 0;
//    }

//    // Check for vertical collision.
//    if (lhc_collision_vertical()) {
//        // Stop further y-axis movement this step...
//        lhc_stop_y();
//        // AND stop our y velocity.
//        vsp = 0;
//		vsp_final = 0;
//    }
//});

function OnGround() {
	if (place_meeting(x,y+1,SOLID_INTERFACE)) {
		return true;
	} else return false;
}

function Keys() {
	moveL = keyboard_check(vk_left) || keyboard_check(ord("A"));
	moveR = keyboard_check(vk_right) || keyboard_check(ord("D"));
	moveJ = keyboard_check(vk_up) || keyboard_check(vk_space);
	moveB = keyboard_check_pressed(vk_backspace) || keyboard_check_pressed(ord("R"));
}

function Moving() {
	hsp = (moveR - moveL) * mspd;
	if (vsp<10) vsp += grav;
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
	if (place_meeting(x+hsp_final,y,SOLID_INTERFACE))
	{
	    var inc = sign(hsp_final);
	    while (!place_meeting(x+inc,y,SOLID_INTERFACE)) x+= inc;
	    hsp_final = 0;
	    hsp = 0;
	}
 
	if (place_meeting(x,y+vsp_final,SOLID_INTERFACE))
	{
	    var inc = sign(vsp_final);
	    while (!place_meeting(x,y+inc,SOLID_INTERFACE)) y+= inc;
	    vsp_final = 0;
	    vsp = 0;
	}
	//final move
	x += hsp_final
	y += vsp_final;
}

function ObstacleHandling() {
	if (place_meeting(x,y,OBSTACLE_INTERFACE)) or (moveB) or (y > room_height + 32)  {
		attempts++;
		x = x_start;
		y = y_start;
		audio_play_sound(snd_lose,0,false)
		//TODO: play sound for death
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
	
	depth = -9999999;
}

Initialize();