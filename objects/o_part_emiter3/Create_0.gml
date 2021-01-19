part_sys = new advanced_part_system();
part_emitter_ = new advanced_part_emitter(part_sys, x-20, y-20, x+20, y+20, x, y);

part_type_ = new advanced_part_type();
with(part_type_) {
	//lifetime
	part_life(30,30);
	//looks
	part_image(s_pixel, 0, c_aqua, false, false, false);
	part_size(0.5, 2, 0, 0);
	part_orientation(0, 359, 0, 0, false);
	//moving
	part_gravity(0,0,0);
	part_speed(1, 3, 0, 0);
	part_direction(80, 100, 0, 0);
}

part_type_2 = new advanced_part_type();
with(part_type_2) {
	//lifetime
	part_life(30,30);
	//looks
	part_image(s_pixel, 0, c_lime, false, false, false);
	part_size(1, 3, 0, 0);
	part_orientation(0, 359, 0, 0, false);
	//moving
	part_gravity(0,0,0);
	part_speed(1, 3, 0, 0);
	part_direction(-10, 10, 0, 0);
}

part_type_3 = new advanced_part_type();
with(part_type_3) {
	//lifetime
	part_life(60,120);
	//looks
	part_image(s_heart, 0, c_red, false, false, false);
	part_size(1, 2, 0, 0);
	part_orientation(0, 359, 0, 0, false);
	//moving
	part_gravity(270,1.25,0);
	part_speed(1, 3, 0, 0);
	part_direction(-10, 10, 0, 0);
}

part_type_.part_dead = part_type_2;
part_type_2.part_dead = part_type_3;