ps = new advanced_part_system();
ps.particle_system_debug_mode = global.particles_debug_mode;
ps.enabledelta();

em = new advanced_part_emitter(ps, x-4, x+4, y-2, y+2, aps_shape.ellipse, aps_distr.linear);

boom_part = new advanced_part_type();
with(boom_part) {
	//lifetime
	part_life(60 / 60, 120 / 60);
	//looks
	part_image(sFirework, 0, c_white, false, false, true);
	part_size(0.02, 0.05, -0.00025 * 60, 0);
	part_orientation(0, 360, 0, 0, false);
	part_alpha3(0.75, 1, 0);
	part_blend(true);
	//moving
	part_gravity(0.005 * 60 * 60, 270);
	part_speed(0.01 * 60, 0.5 * 60, 0, 0);
	part_direction(0, 360, 0, 0);
}

cinder_part = new advanced_part_type();
with(cinder_part) {
	//lifetime
	part_life(90 / 60, 140 / 60);
	//looks
	part_image(s_pixel, 0, c_white, false, false, true);
	part_size(0.25, 0.5, 0, 0);
	part_orientation(0, 0, 0, 0, false);
	part_color3(c_yellow, c_yellow, c_red);
	part_alpha3(1, 1, 0);
	//moving
	part_gravity(0.005 * 60 * 60, 270);
	part_speed(0.05 * 60, 0.2 * 60, 0, 0);
	part_direction(0, 360, 0, 0);
}

fire_part = new advanced_part_type();
with(fire_part) {
	//lifetime
	part_life(60 / 60, 90 / 60);
	//looks
	part_image(s_pixel, 0, c_white, false, false, false);
	part_size(0.5, 0.5, 0, 0);
	part_orientation(0, 359, 0, 0, false);
	part_alpha3(1, 1, 0);
	//moving
	part_gravity(0.01 * 60 * 60, 270);
	part_speed(1 * 60, 2 * 60, 0, 0);
	part_direction(90-15, 90+15, 0, 0);
	
	part_death(50, other.boom_part);
	part_step(10, other.cinder_part);
}