ps = new advanced_part_system();
part_emiter_ = new advanced_part_emitter(ps, x-20,x+20,y-20,y+20,x,y);

part_type_ = new advanced_part_type();
part_type_.part_gravity(270, 0.1, 0);
part_type_.part_life(60, 120);
part_type_.part_transform(0, 0, 1, 1, 1, 1, true);
part_type_.part_image(s_pixel, 0, c_white, false, false, false);
part_type_.part_move(0, 359, 0.25, 0.25);

part_type_2 = new advanced_part_type();
part_type_2.part_gravity(90,0.1,0.1);
part_type_2.part_life(25,35);
part_type_2.part_transform(0,0,0.25,1,0.25,1,true);
part_type_2.part_image(s_pixel, 0, c_red, false, false, false);
part_type_2.part_move(0,359,0.5,1);

part_type_.part_dead = part_type_2;