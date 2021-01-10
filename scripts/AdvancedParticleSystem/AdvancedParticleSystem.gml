function advanced_part_system() constructor {
	
	particle_list = ds_list_create();
	
	//Camera check function
	var cam = view_camera[0];
	part_system_view_width = camera_get_view_width(cam);
	part_system_view_height = camera_get_view_height(cam);
	part_system_view_x = camera_get_view_x(cam);
	part_system_view_y = camera_get_view_y(cam);
	
	function get_view(x, y, width, height) {
		//return true if particle is in view
		return (x + width / 2) > part_system_view_x && (x - width / 2) < part_system_view_x + part_system_view_width
			&& (y + height / 2) > part_system_view_y && (y - height / 2) < part_system_view_y + part_system_view_height;
	}
	
	//Deltatime function
	part_system_deltatime = false;
	
	function enabledelta() {
		if !instance_exists(oSteadyDeltaTime) {
			instance_create_depth(0, 0, 9999, oSteadyDeltaTime);
		}
		part_system_deltatime = true;
	}
	
	//Particles updating
	function step() {
		//update camera position info
		var cam = view_camera[0];
		part_system_view_x = camera_get_view_x(cam);
		part_system_view_y = camera_get_view_y(cam);
		
		//calculate deltatime
		var part_system_delta = part_system_deltatime ? global.dt_steady : 1;
		
		//update particles
		if !ds_list_empty(particle_list) {
			var _size = ds_list_size(particle_list);
			for (var i = 0; i < _size; i++) {
				var _particle = ds_list_find_value(particle_list, i);
				if _particle {
					//update every particle
					with(_particle) {
						
						var x_speed = dcos(direction) * speed; //lengthdir_x(speed, direction); //
						var y_speed = -dsin(direction) * speed; //lengthdir_y(speed, direction); //
						
						if gravity_speed != 0 {
							gravity += gravity_speed * part_system_delta;
							x_speed += dcos(gravity_direction) * gravity; //lengthdir_x(gravity, gravity_direction); //
							y_speed += -dsin(gravity_direction) * gravity; //lengthdir_y(gravity, gravity_direction); //
						}
						if point_gravity_speed != 0 && emitter {
							point_gravity += point_gravity_speed;
							var gravity_dir = point_direction(x, y, emitter.point_gravity_x, emitter.point_gravity_y);
							x_speed += dcos(gravity_dir) * point_gravity; //lengthdir_x(point_gravity, gravity_dir); //
							y_speed += -dsin(gravity_dir) * point_gravity; //lengthdir_y(point_gravity, gravity_dir); //
						}
						
						x += x_speed * part_system_delta;
						y += y_speed * part_system_delta;
						
						life -= part_system_delta;
						
						//Changing color
						if colors_enabled {
							var percent = 1 - (life / life_max);
							
							if percent <= 0.5 {
								color = merge_colour(color1, color2, percent * 2);
							} else {
								color = merge_colour(color2, color3, percent * 2 - 1);
							}
						}
						
						//Changing alpha
						if alpha_blend_enabled {
							var percent = 1 - (life / life_max);
							
							if percent <= 0.5 {
								alpha = lerp(alpha1, alpha2, percent * 2);
							} else {
								alpha = lerp(alpha2, alpha3, percent * 2 - 1);
							}
						}
						
						//destroy particles
						if life <= 0 {
							if dead_part {
								var part = new particle(dead_part);
								with(part) {
									emitter = other.emitter;
									x = other.x;
									y = other.y;
								}
								ds_list_replace(other.particle_list, i, part);
							} else {
								ds_list_delete(other.particle_list, i);
								i--;
							}
						}
					}
				}
			}
		}
	}
	
	//Particles drawing
	function draw() {
		if !ds_list_empty(particle_list) {
			var _size = ds_list_size(particle_list);
			for (var i = 0; i < _size; i++) {
				var particle = ds_list_find_value(particle_list, i);
				if particle {
					//draw every particle if it is in view
					if get_view(particle.x, particle.y, particle.part_width, particle.part_height)
					with(particle) {
						
						if additiveblend gpu_set_blendmode(bm_add); //TEMPORARY
						
						if (x_scale == 1 && x_scale == y_scale && angle == 0 && color == c_white && alpha == 1) {
							draw_sprite(sprite, subimg, x-part_width_half, y-part_height_half);
						} else {
							draw_sprite_ext(sprite, subimg, x-part_width_half, y-part_height_half, x_scale, y_scale, angle, color, alpha);
						}
						
						if additiveblend gpu_set_blendmode(bm_normal); //TEMPORARY
					}
				}
			}
		}
	}
}

//Basic particle
function particle(part_type) constructor {
	emitter = noone;
		
	color = part_type.part_color;
	alpha = 1;
		
	self.colors_enabled = part_type.colors_enabled;
	if colors_enabled {
		self.color1 = part_type.part_color1;
		self.color2 = part_type.part_color2;
		self.color3 = part_type.part_color3;
		color = color1;
	}
		
	self.alpha_blend_enabled = part_type.alpha_blend_enabled;
	if alpha_blend_enabled {
		self.alpha1 = part_type.part_alpha1;
		self.alpha2 = part_type.part_alpha2;
		self.alpha3 = part_type.part_alpha3;
		alpha = alpha1;
	}
		
	self.additiveblend = part_type.part_additiveblend;
		
	sprite = part_type.part_sprite;
	subimg = part_type.part_subimg; if (part_type.part_subimg_random) subimg = irandom(sprite_get_number(sprite) - 1);
	angle = random_range(part_type.angle_min,part_type.angle_max);
	life = irandom_range(part_type.part_time_min,part_type.part_time_max);
	life_max = life;
	x_scale = random_range(part_type.part_xscale_min,part_type.part_xscale_max);
	if part_type.part_scale_equal {
		y_scale = x_scale;
	} else {
		y_scale = random_range(part_type.part_yscale_min,part_type.part_yscale_max);
	}
	part_width = part_type.part_sprite_width * x_scale;
	part_height = part_type.part_sprite_height * y_scale;
	part_width_half = part_width / 2;
	part_height_half = part_height / 2;
		
	self.x = 0;
	self.y = 0;
	direction = random_range(part_type.part_direction_min,part_type.part_direction_max);
	speed = random_range(part_type.part_speed_min,part_type.part_speed_max);
	gravity = 0;
	gravity_direction = part_type.part_gravity_direction;
	gravity_speed = part_type.part_gravity_speed;
	point_gravity = 0;
	point_gravity_speed = part_type.part_gravity_point_speed;
		
	dead_part = part_type.part_dead;
}

function advanced_part_emitter(ps, xmin, xmax, ymin, ymax, gravity_point_x, gravity_point_y) constructor {
	part_sys = ps;
	
	x_left = xmin;
	x_right = xmax;
	y_top = ymin;
	y_down = ymax;
	
	point_gravity_x = gravity_point_x;
	point_gravity_y = gravity_point_y;
}

function advanced_part_type() constructor {
	part_sprite = noone;
	part_color = c_white;
	
	colors_enabled = false;
	part_color1 = c_white;
	part_color2 = c_white;
	part_color3 = c_white;
	
	alpha_blend_enabled = false;
	part_alpha1 = c_white;
	part_alpha2 = c_white;
	part_alpha3 = c_white;
	
	part_additiveblend = false;
	
	angle_min = 0;
	angle_max = 359;
	part_time_min = 60;
	part_time_max = 90;
	part_xscale_min = 1;
	part_xscale_max = 1;
	part_scale_equal = true;
	part_yscale_min = 1;
	part_yscale_max = 1;
	
	part_sprite_width = sprite_get_width(part_sprite);
	part_sprite_height = sprite_get_height(part_sprite);
	
	part_direction_min = 0;
	part_direction_max = 359;
	part_speed_min = 1;
	part_speed_max = 2;
	
	part_gravity_direction = 0;
	part_gravity_speed = 0;
	part_gravity_point_speed = 0;
	
	part_dead = noone;
	
	function part_image(sprite, subimg, color, animate, stretch, random) {
		self.part_sprite = sprite;
		self.part_subimg = subimg;
		self.part_color = color;
		self.part_animate = animate;
		self.part_stretch = stretch;
		self.part_subimg_random = random;
	}
	
	function part_color3(color1, color2, color3) {
		self.colors_enabled = true;
		self.part_color1 = color1;
		self.part_color2 = color2;
		self.part_color3 = color3;
	}
	
	function part_alpha3(alpha1, alpha2, alpha3) {
		self.alpha_blend_enabled = true;
		self.part_alpha1 = alpha1;
		self.part_alpha2 = alpha2;
		self.part_alpha3 = alpha3;
	}
	
	function part_blend(additive) {
		self.part_additiveblend = additive;
	}
	
	function part_transform(angle_min_, angle_max_, x_scale_min, x_scale_max, y_scale_min, y_scale_max, scale_equal) {
		self.angle_min = angle_min_;
		self.angle_max = angle_max_;
		self.part_xscale_min = x_scale_min;
		self.part_xscale_max = x_scale_max;
		self.part_scale_equal = scale_equal;
		self.part_yscale_min = y_scale_min;
		self.part_yscale_max = y_scale_max;
	}
	
	function part_life(life_min, life_max) {
		self.part_time_min = life_min;
		self.part_time_max = life_max;
	}
	
	function part_gravity(gravity_dir, gravity_speed, point_gravity_speed) {
		self.part_gravity_direction = gravity_dir;
		self.part_gravity_speed = gravity_speed;
		self.part_gravity_point_speed = point_gravity_speed;
	}
	
	function part_move(direction_min, direction_max, speed_min, speed_max) {
		self.part_direction_min = direction_min;
		self.part_direction_max = direction_max;
		self.part_speed_min = speed_min;
		self.part_speed_max = speed_max;
	}
}

function advanced_part_emitter_burst(ps, part_emit, part_type, number) {
	if !ps.part_system_deltatime {
		//Burst particles without deltatime (create numbers of particles each step)
		repeat(number) {
			var part = new particle(part_type);
			with(part) {
				emitter = part_emit;
				x = random_range(emitter.x_left, emitter.x_right);
				y = random_range(emitter.y_top, emitter.y_down);
			}
			ds_list_add(ps.particle_list, part);
		}
	} else {
		//Burst particles with deltatime (create numbers of particles within a second)
		if (round(global.continuousDeltaTimer * 10) mod max(1, round(1 / number * 10))) == 0 {
			var part = new particle(part_type);
			with(part) {
				emitter = part_emit;
				x = random_range(emitter.x_left, emitter.x_right);
				y = random_range(emitter.y_top, emitter.y_down);
			}
			ds_list_add(ps.particle_list, part);
		}
	}
}

function advanced_part_particles_create(ps, x, y, part_type, number) {
	repeat(number) {
		var part = new particle(part_type);
		with(part) {
			self.x = x;
			self.y = y;
		}
		ds_list_add(ps.particle_list, part);
	}
}

function advanced_part_emitter_region(part_emit, xmin, xmax, ymin, ymax, gravity_point_x, gravity_point_y) {
	with(part_emit) {
		x_left = xmin;
		y_top = ymin;
		x_right = xmax;
		y_down = ymax;
	
		point_gravity_x = gravity_point_x;
		point_gravity_y = gravity_point_y;
	}
}

function advanced_part_system_destroy(id) {
	with(id) ds_list_destroy(particle_list);
	delete id;
}