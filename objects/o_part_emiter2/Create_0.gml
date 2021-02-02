part_sys = new advanced_part_system();
part_emitter1 = new advanced_part_emitter(part_sys, x-20, x+20, y, y, aps_shape.rectangle, aps_distr.linear);

part_type1 = new advanced_part_type();
with(part_type1) {
	part_point_gravity(0.15, other.x, other.y);
	part_life(150,200);
	part_size(0.5, 3, 0, 0);
	part_image(s_pixel, 0, c_aqua, false, false, false);
	part_speed(2, 5, 0, 0);
	part_direction(0, 359, 0, 0);
	part_blend(true);
	part_alpha3(0, 1, 0);
}

part_emitter2 = new advanced_part_emitter(part_sys, x-12, x+12, y, y, aps_shape.rectangle, aps_distr.linear);
part_type2 = new advanced_part_type();
with(part_type2) {
	part_life(30,60);
	part_size(0.5, 2, 0, 0);
	part_image(s_pixel, 0, c_aqua, false, false, false);
	part_speed(2, 5, 0, 0);
	part_direction(70, 110, 0, 0);
	part_alpha3(1, 1, 0);
}