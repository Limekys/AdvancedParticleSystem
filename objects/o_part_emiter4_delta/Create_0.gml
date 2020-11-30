ps = new advanced_part_system();
ps.enabledelta();

part_emiter_ = new advanced_part_emitter(ps, x-20, y-20, x+20, y+20, x, y);
part_type_ = new advanced_part_type();
part_type_.part_gravity(270, 6, -3);
part_type_.part_life(1.0, 2.0);
part_type_.part_transform(0, 0, 1, 1, 1, 1, true);
part_type_.part_image(s_pixel, c_white);
part_type_.part_move(0, 359, 15, 15);