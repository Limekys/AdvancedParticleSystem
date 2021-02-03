advanced_part_emitter_burst(ps, em, fire_part, 1);
advanced_part_emitter_burst(ps, em, cinder_part, 1);

//move towards mouse
advanced_part_emitter_region(em, mouse_x-16-2, mouse_x-16+2, mouse_y, mouse_y-2, aps_shape.ellipse, aps_distr.linear);

ps.step();