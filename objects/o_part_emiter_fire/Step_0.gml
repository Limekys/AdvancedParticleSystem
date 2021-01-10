advanced_part_emitter_burst(ps, em, part_3, 1);
advanced_part_emitter_burst(ps, em, part_1, 2);

//move towards mouse
advanced_part_emitter_region(em, mouse_x-2, mouse_x+2, mouse_y, mouse_y-2, room_width-mouse_x, room_height-mouse_y);

//test particle create
if mouse_check_button(mb_right)
advanced_part_particles_create(ps, mouse_x, mouse_y, part_type_, 1);

ps.step();