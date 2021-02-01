ps = new advanced_part_system();

part_emiter_ = new advanced_part_emitter(ps, x-20, x+20, y-20, y+20, x, y, aps_shape.rectangle, aps_distr.linear);

part_type1 = new advanced_part_type();
with(part_type1) {
	part_gravity(270, 0.1, 0);
	part_life(60, 120);
	part_size(1, 1, 0, 0);
	part_orientation(0, 0, 0, 0, false);
	part_image(s_pixel, 0, c_white, false, false, false);
	part_speed(0.25, 0.25, 0, 0);
	part_direction(0, 359, 0, 0);
}