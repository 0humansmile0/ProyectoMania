if global.time_start {
	var _str = string(@"{0}:{1}:{2}
	",
	string_replace_all(string_format(global.time_m, 2, 0), " ", "0"),
	string_replace_all(string_format(global.time_s, 2, 0), " ", "0"),
	string_replace_all(string_format(floor(global.time_ms), 2, 0), " ", "0"))
	
	draw_set_font(fnt_default);
	draw_set_colour(c_white);
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	
	draw_text(1280/2,0,_str);
}