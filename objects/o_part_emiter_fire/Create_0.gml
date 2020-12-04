ps = new advanced_part_system();
em = new advanced_part_emitter(ps, x-4, y-2, x+4, y+2, x, y);
part_1 = new advanced_part_type();
part_1.part_gravity(90, 0.01, 0);
part_1.part_life(60, 90);
part_1.part_transform(0, 359, 0.05, 0.2, 1, 1, true);
part_1.part_image(sFireParticles, 0, c_white, false, false, true);
part_1.part_move(0, 359, 0, 0);
part_1.part_colors(c_white, c_yellow, c_red);
part_1.part_alpha_blend(1, 1, 0);

part_2 = new advanced_part_type();
part_2.part_gravity(90, 0.005, 0);
part_2.part_life(60, 120);
part_2.part_transform(0, 359, 0.1, 0.25, 1, 1, true);
part_2.part_image(sParticleSmoke, 0, c_dkgray, false, false, false);
part_2.part_move(45, 180-45, 0.05, 0.1);
part_2.part_colors(c_dkgray, c_gray, c_ltgray);
part_2.part_alpha_blend(0.1, 0.1, 0);

part_1.part_dead = part_2;

part_3 = new advanced_part_type();
part_3.part_gravity(90, 0.005, 0);
part_3.part_life(90, 140);
part_3.part_transform(0, 0, 0.25, 0.5, 1, 1, true);
part_3.part_image(s_pixel, 0, c_white, false, false, true);
part_3.part_move(80, 180-80, 0.1, 0.3);
part_3.part_colors(c_yellow, c_yellow, c_red);
part_3.part_alpha_blend(0, 1, 0);