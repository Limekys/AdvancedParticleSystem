advanced_part_emitter_burst(ps, em, fire_part, 60);
advanced_part_emitter_burst(ps, em, cinder_part, 60);

//move towards mouse
advanced_part_emitter_region(em, mouse_x+16-2, mouse_x+16+2, mouse_y, mouse_y-2, room_width-mouse_x, room_height-mouse_y);

//test particle create
if mouse_check_button(mb_right)
advanced_part_particles_create(ps, mouse_x, mouse_y, other_part, 1);

ps.step();