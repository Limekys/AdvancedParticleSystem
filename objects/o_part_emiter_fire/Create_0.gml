ps = new advanced_part_system();

em = new advanced_part_emitter(ps, x-4, x+4, y-2, y+2, x, y, aps_shape.ellipse, aps_distr.linear);

fire_part = new advanced_part_type();
with(fire_part) {
	//lifetime
	part_life(60, 90);
	//looks
	part_image(sFireParticles, 0, c_white, false, false, true);
	part_size(0.05, 0.2, -0.001, 0);
	part_orientation(0, 359, 1, 0, false);
	part_color3(c_white, c_yellow, c_red);
	part_alpha3(1, 1, 0);
	part_blend(true);
	//moving
	part_gravity(90, 0.01, 0);
	part_speed(0, 0, 0, 0);
}


smoke_part = new advanced_part_type();
with(smoke_part) {
	//lifetime
	part_life(60, 120);
	//looks
	part_image(sParticleSmoke, 0, c_dkgray, false, false, false);
	part_size(0.1, 0.25, 0, 0);
	part_color3(c_dkgray, c_gray, c_ltgray);
	part_alpha3(0.1, 0.1, 0);
	//moving
	part_gravity(90, 0.005, 0);
	part_speed(0.05, 0.1, 0, 0);
	part_direction(45, 180-45, 0, 0);
}

fire_part.part_dead = smoke_part;

cinder_part = new advanced_part_type();
with(cinder_part) {
	//lifetime
	part_life(90, 140);
	//looks
	part_image(s_pixel, 0, c_white, false, false, true);
	part_size(0.25, 0.5, 0, 0);
	part_orientation(0, 0, 0, 0, false);
	part_color3(c_yellow, c_yellow, c_red);
	part_alpha3(0, 1, 0);
	//moving
	part_gravity(90, 0.005, 0);
	part_speed(0.1, 0.3, 0, 0);
	part_direction(80, 180-80, 0, 0);
}



other_part = new advanced_part_type();
with(other_part) {
	//lifetime
	part_life(150,200);
	//looks
	part_size(0.5,3, 0, 0);
	part_image(s_pixel, 0, c_aqua, false, false, false);
	part_blend(true);
	part_alpha3(0, 1, 0);
	//moving
	part_gravity(0,0,0.15);
	part_speed(2,5, 0, 0);
}