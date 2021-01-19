ps = new advanced_part_system();
ps.enabledelta();
part_emiter_ = new advanced_part_emitter(ps, x-20,x+20,y-20,y+20,x,y);

part_type1 = new advanced_part_type();
part_type1.part_gravity(270, 0.1 * 60 * 60, 0);
part_type1.part_life(1, 2);
part_type1.part_size(1, 1, 0, 0);
part_type1.part_orientation(0, 0, 0, 0, false);
part_type1.part_image(s_pixel, 0, c_white, false, false, false);
part_type1.part_speed(0.25 * 60, 0.25 * 60, 0, 0);

part_type2 = new advanced_part_type();
part_type2.part_gravity(90, 0.1 * 60, 0.1 * 60);
part_type2.part_life(25 / 60, 35 / 60);
part_type2.part_size(0.25,1, 0, 0);
part_type2.part_orientation(0, 0, 0, 0, false);
part_type2.part_image(s_pixel, 0, c_red, false, false, false);
part_type2.part_speed(0.5 * 60, 1 * 60, 0, 0);

//part_type1.part_dead = part_type2;