ps.step();

advanced_part_emitter_burst(ps, em, fire_part, 1);

//Create firework on mouse position
if mouse_check_button_pressed(mb_left) {
	advanced_part_particles_create(ps, mouse_x, mouse_y, fire_part, 1);
}
if mouse_check_button(mb_right) {
	advanced_part_particles_create(ps, mouse_x, mouse_y, fire_part, 1);
}