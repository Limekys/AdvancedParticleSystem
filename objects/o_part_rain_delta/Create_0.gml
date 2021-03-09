ps = new advanced_part_system();
ps.particle_system_debug_mode = global.particles_debug_mode;
ps.enabledelta();
pe = new advanced_part_emitter(ps, 0, room_width, -16, -64, aps_shape.rectangle, aps_distr.linear);

water_drops = new advanced_part_type();
with(water_drops) {
	part_gravity(0.05 * 60 * 60, 270);
	part_speed(32, 64, 0, 0);
	part_direction(90+30, 90-30, 0, 0);
	part_life(1, 1);
	part_image(s_pixel, 0, c_aqua, false, false, false);
	part_scale(0.5, 0.25);
	part_size(0.5, 0.5, 0, 0);
	part_orientation(0, 360, 0, 0, true);
	part_scale(1, 2);
	part_alpha3(0.5, 0.5, 0);
	part_step_function(
		function() {
			if y > room_height-16 && life < life_max/1.1 {
				life = 0;
			}
		}
	);
}

water = new advanced_part_type();
with(water) {
	part_gravity(0.5 * 60 * 60, 270);
	part_life(10, 100);
	part_image(s_pixel, 0, c_aqua, false, false, false);
	part_scale(0.5, 5);
	part_alpha3(0.5, 0.5, 0.5);
	part_death(5, other.water_drops);
	part_step_function(
		function() {
			if y > room_height-20 {
				y = room_height-16;
				life = 0;
			}
		}
	);
}