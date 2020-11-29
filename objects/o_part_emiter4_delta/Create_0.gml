ps = new advanced_part_system();
ps.part_system_deltatime = true;

part_emiter_ = new advanced_part_emitter(ps, x-20,y-20,x+20,y+20,x,y);
part_type_ = new advanced_part_type();
part_type_.part_gravity(0, 0, 0);
part_type_.part_life(0.5, 1.0);
part_type_.part_transform(0, 0, 1, 1, 1, 1, true);
part_type_.part_image(s_pixel, c_white);
part_type_.part_move(0, 359, 30, 30);