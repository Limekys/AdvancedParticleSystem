part_sys = new advanced_part_system();
part_emitter_ = new advanced_part_emitter(part_sys, x-20, y-20, x+20, y+20, x, y);
part_type_ = new advanced_part_type();
part_type_.part_gravity(0,0,0);
part_type_.part_life(30,30);
part_type_.part_transform(0,359,0.5,2,1,1,true);
part_type_.part_image(s_pixel,c_aqua);
part_type_.part_move(80,100,1,3);

part_type_2 = new advanced_part_type();
part_type_2.part_gravity(0,0,0);
part_type_2.part_life(30,30);
part_type_2.part_transform(0,359,1,3,1,1,true);
part_type_2.part_image(s_pixel,c_lime);
part_type_2.part_move(-10,10,1,3);

part_type_3 = new advanced_part_type();
part_type_3.part_gravity(270,0.25,0);
part_type_3.part_life(30,30);
part_type_3.part_transform(0,359,1,2,1,1,true);
part_type_3.part_image(s_heart, c_red);
part_type_3.part_move(-10,10,1,3);

part_type_.part_dead = part_type_2;
part_type_2.part_dead = part_type_3;