ps = new advanced_part_system();
em = new advanced_part_emitter(ps, x-4, x+4, y-2, y+2, x, y);

fire_part = new advanced_part_type();
fire_part.part_life(60, 90);
//looks
fire_part.part_image(sFireParticles, 0, c_white, false, false, true);
fire_part.part_size(0.05, 0.2, -0.001, 0);
fire_part.part_orientation(0, 359, 1, 0, false);
fire_part.part_color3(c_white, c_yellow, c_red);
fire_part.part_alpha3(1, 1, 0);
fire_part.part_blend(true);
//moving
fire_part.part_gravity(90, 0.01, 0);
fire_part.part_speed(0, 0, 0, 0);


smoke_part = new advanced_part_type();
smoke_part.part_life(60, 120);
//looks
smoke_part.part_image(sParticleSmoke, 0, c_dkgray, false, false, false);
smoke_part.part_size(0.1, 0.25, 0, 0);
smoke_part.part_color3(c_dkgray, c_gray, c_ltgray);
smoke_part.part_alpha3(0.1, 0.1, 0);
//moving
smoke_part.part_gravity(90, 0.005, 0);
smoke_part.part_speed(0.05, 0.1, 0, 0);
smoke_part.part_direction(45, 180-45, 0, 0);

fire_part.part_dead = smoke_part;


cinder_part = new advanced_part_type();
cinder_part.part_life(90, 140);
//looks
cinder_part.part_image(s_pixel, 0, c_white, false, false, true);
cinder_part.part_size(0.25, 0.5, 0, 0);
cinder_part.part_orientation(0, 0, 0, 0);
cinder_part.part_color3(c_yellow, c_yellow, c_red);
cinder_part.part_alpha3(0, 1, 0);
//moving
cinder_part.part_gravity(90, 0.005, 0);
cinder_part.part_speed(0.1, 0.3, 0, 0);
cinder_part.part_direction(80, 180-80, 0, 0);


other_part = new advanced_part_type();
other_part.part_life(150,200);
//looks
other_part.part_size(0.5,3, 0, 0);
other_part.part_image(s_pixel, 0, c_aqua, false, false, false);
other_part.part_blend(true);
other_part.part_alpha3(0, 1, 0);
//moving
other_part.part_gravity(0,0,0.15);
other_part.part_speed(2,5, 0, 0);