ps = new advanced_part_system();
pe = new advanced_part_emitter(ps, x-20 - 96, x+20 -96 + 40, y-20, y+20, aps_shape.ellipse, aps_distr.linear);

part_type1 = new advanced_part_type();
with(part_type1) {
	part_life(100, 500);
	part_size(0.5, 1, 0.01, 1);
	part_orientation(0, 359, 0, 0, false);
	part_image(s_pixel_big, 0, c_white, false, false, false);
	part_speed(0.1, 0.2, -0.001, 0);
	part_direction(0, 359, 0, 0);
}

//OLD for compare
part_sys = part_system_create();
part_emit = part_emitter_create(part_sys);
part_emitter_region(part_sys, part_emit, x-20 + 96 - 40, x+20 + 96, y-20, y+20, ps_shape_ellipse, ps_distr_linear);

part = part_type_create();
part_type_life(part, 100, 500);
part_type_size(part, 0.5, 1, 0.01, 1);
part_type_orientation(part, 0, 359, 0, 0, 0);
part_type_sprite(part, s_pixel_big, false, false, false);
part_type_speed(part, 0.1, 0.2, -0.001, 0);
part_type_direction(part, 0, 359, 0, 0);