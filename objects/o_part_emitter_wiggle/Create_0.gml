ps = new advanced_part_system(); ps.particle_system_debug_mode = global.particles_debug_mode;
pe = new advanced_part_emitter(ps, x-20, x+20, y-20, y+20, aps_shape.ellipse, aps_distr.linear);

part_type1 = new advanced_part_type();
with(part_type1) {
	part_life(100, 500);
	part_size(0.5, 1, 0.01, 0.2);
	part_orientation(0, 359, 0, 0, false);
	part_image(s_pixel_big, 0, c_white, false, false, false);
	part_speed(0.1, 0.2, -0.001, 0);
	part_direction(0, 359, 0, 0);
}