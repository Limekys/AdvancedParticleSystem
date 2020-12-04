advanced_part_burst(ps, em, part_3, 1);
advanced_part_burst(ps, em, part_1, 2);

//move towards mouse
advanced_part_emit_region(em, mouse_x-2, mouse_x+2, mouse_y, mouse_y-2, room_width-mouse_x, room_height-mouse_y);

ps.step();