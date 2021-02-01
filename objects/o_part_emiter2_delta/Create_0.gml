part_sys = new advanced_part_system();
part_sys.enabledelta();
part_emitter1 = new advanced_part_emitter(part_sys, x-20, x+20, y, y, x, y, aps_shape.rectangle, aps_distr.linear);

part_type1 = new advanced_part_type();
part_type1.part_gravity(0, 0, 0.15 * 60 * 60);
part_type1.part_life(150 / 60, 200 / 60);
part_type1.part_size(0.5, 3, 0, 0);
part_type1.part_image(s_pixel, 0, c_aqua, false, false, false);
part_type1.part_speed(2 * 60, 5 * 60, 0, 0);
part_type1.part_direction(0, 359, 0, 0);
part_type1.part_blend(true);
part_type1.part_alpha3(0, 1, 0);

part_emitter2 = new advanced_part_emitter(part_sys, x-12, x+12, y, y, x, y, aps_shape.rectangle, aps_distr.linear);
part_type2 = new advanced_part_type();
part_type2.part_gravity(0, 0, 0);
part_type2.part_life(30 / 60, 60 / 60);
part_type2.part_size(0.5, 2, 0, 0);
part_type2.part_image(s_pixel, 0, c_aqua, false, false, false);
part_type2.part_speed(2 * 60, 5 * 60, 0, 0);
part_type2.part_direction(70, 110, 0, 0);
part_type2.part_alpha3(1, 1, 0);

