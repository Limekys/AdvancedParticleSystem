part_sys = part_system_create();

part_emit = part_emitter_create(part_sys);
part_emitter_region(part_sys, part_emit, x-20, x+20, y-20, y+20, ps_shape_rectangle, ps_distr_linear);

part = part_type_create();
//part_type_gravity(part, 0.1, 270);
part_type_life(part, 60, 120);
part_type_size(part, 0.1, 0.1, 0, 0);
part_type_orientation(part, 0, 0, 0, 0, 0);
part_type_speed(part, 0.25, 0.25, 0, 0);
part_type_direction(part, 0, 359, 0, 0);
part_type_sprite(part, sSmokePlume, true, false, false);