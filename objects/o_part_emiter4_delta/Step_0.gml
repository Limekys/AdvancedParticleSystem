advanced_part_burst(ps, part_emiter_, part_type_, global.dt_steady * 60 * 30);

//move towards mouse
//advanced_part_emit_region(part_emiter_, mouse_x-20, mouse_x+20, mouse_y-20, mouse_y+20, room_width-mouse_x, room_height-mouse_y);

ps.step();