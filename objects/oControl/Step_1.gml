/// @desc 
if update <= 0 {
	fps_real_ = fps_real;
	update = 15;
}

update--;

if end_game_when_low_fps && fps_real_ < 5 game_end();