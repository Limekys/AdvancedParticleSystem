ps = new advanced_part_system();
part_emiter_ = new advanced_part_emitter(ps, x-20, x+20, y-20, y+20, x, y, aps_shape.rectangle, aps_distr.linear);

part_type1 = new advanced_part_type();
//part_type1.part_gravity(270, 0.1, 0);
//part_type1.part_life(60, 120);
//part_type1.part_size(1, 1, 0, 0);
//part_type1.part_orientation(0, 0, 0, 0, false);
//part_type1.part_image(s_pixel, 0, c_white, false, false, false);
//part_type1.part_speed(0.25, 0.25, 0, 0);
with(part_type1) {
	part_gravity(270, 0, 0);
	part_life(120, 120);
	part_size(1, 1, 0.1, 0);
	part_orientation(0, 359, 0.5, 0, true);
	part_image(s_pixel, 0, c_white, false, false, false);
	part_speed(0.25, 0.25, 0.025, 0);
	part_direction(0, 359, 1, 0);
}

//part_type2 = new advanced_part_type();
//part_type2.part_gravity(90,0.1,0.1);
//part_type2.part_life(25,35);
//part_type2.part_size(0.25, 1, 0, 0);
//part_type2.part_orientation(0, 0, 0, 0, false);
//part_type2.part_image(s_pixel, 0, c_red, false, false, false);
//part_type2.part_speed(0.5, 1, 0, 0);

//part_type1.part_dead = part_type2;