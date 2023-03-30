/// @desc Change FPS
room_target_speed -= room_target_speed > 15 ? 15 : 0;
game_set_speed(room_target_speed, gamespeed_fps);