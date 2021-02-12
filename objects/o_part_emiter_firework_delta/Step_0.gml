ps.step();

advanced_part_emitter_burst(ps, em, fire_part, 1);

//move towards mouse
if mouse_check_button_pressed(mb_left) {
	advanced_part_particles_create(ps, mouse_x, mouse_y, fire_part, 1);
}