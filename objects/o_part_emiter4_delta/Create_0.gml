ps = new advanced_part_system();
ps.enabledelta();
part_emiter_ = new advanced_part_emitter(ps, x-20, y-20, x+20, y+20, x, y, aps_shape.rectangle, aps_distr.linear);

part_type_ = new advanced_part_type();
with(part_type_) {
	//lifetime
	part_life(1.0, 2.0);
	//looks
	part_image(s_pixel, 0, c_white, false, false, false);
	part_size(1, 1, 0, 0);
	part_orientation(0, 0, 0, 0, false);
	//moving
	part_gravity(270, 6, -3);
	part_speed(15, 15, 0, 0);
	part_direction(0, 359, 0, 0);
}
