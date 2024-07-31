/// @desc 
display_set_gui_size(1280, 720);
room_target_speed = 60;

fps_real_ = 9999;
update = 0;

show_debug_overlay(true);

end_game_when_low_fps = false;
alarm[0] = 60;

win_h = window_get_height();

global.particles_debug_mode = false;

#macro DEBUG_INIT_TIMER var _tm = get_timer();
#macro DEBUG_PRINT_TIMER print(string_format(((get_timer() - _tm) / 1000000), 1, 8));