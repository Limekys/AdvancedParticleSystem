draw_set_font(fSmall);
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);
draw_text(4, win_h, "room_speed: " + string(room_speed) + " (real_fps: " + string(fps_real_) + ")");
draw_text(4, win_h - 8, "Q - restart room, R - restart game, SPACE - next room");