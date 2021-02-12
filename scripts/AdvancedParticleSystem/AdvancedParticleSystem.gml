enum aps_shape {
	rectangle,
	ellipse,
	diamond,
	line
}

enum aps_distr {
	linear,
	gaussian,
	invgaussian
}

//#macro aps_update_interval 2 //not completed

function advanced_part_system() constructor {
	
	particle_list = ds_list_create();
	
	particle_system_debug_mode = false;
	
	//update_interval = aps_update_interval; //not completed
	
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
		
		//if (update_interval < aps_update_interval) { update_interval++; } else { update_interval = 1; } //not completed
		
		//Update camera position info
		var cam = view_camera[0];
		part_system_view_x = camera_get_view_x(cam);
		part_system_view_y = camera_get_view_y(cam);
		
		//Calculate deltatime
		var part_system_delta = part_system_deltatime ? global.dt_steady : 1;
		
		//Update particles
		if !ds_list_empty(particle_list) {
			var _size = ds_list_size(particle_list);
			for (var i = 0; i < _size; i++) {
				var _particle = ds_list_find_value(particle_list, i);
				if is_struct(_particle) {
					//Update every particle
					with(_particle) {
						
						//Moving
						var x_speed = dcos(direction) * speed * part_system_delta;
						var y_speed = -dsin(direction) * speed * part_system_delta;
						
						if gravity_speed != 0 {
							gravity += gravity_speed * part_system_delta;
							x_speed += dcos(gravity_direction) * gravity * part_system_delta;
							y_speed += -dsin(gravity_direction) * gravity * part_system_delta;
						}
						if point_gravity_speed != 0 {
							point_gravity += point_gravity_speed * part_system_delta;;
							var point_gravity_dir = point_direction(x, y, point_gravity_x, point_gravity_y);
							x_speed += dcos(point_gravity_dir) * point_gravity * part_system_delta;
							y_speed += -dsin(point_gravity_dir) * point_gravity * part_system_delta;
						}
						
						x += x_speed;
						y += y_speed;
						
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
						
						//Changing direction (direction_increase)
						if direction_increase != 0 {
							direction += direction_increase * part_system_delta;
						}
						
						//Changing speed (speed_increase)
						if speed_increase != 0 && speed > 0 {
							speed += speed_increase * part_system_delta;
						}
						
						//Changing angle (angle_increase, angle_relative)
						if angle_relative {
							angle = direction;
						} else if angle_increase != 0 {
							angle += angle_increase * part_system_delta;
						}
						if angle_wiggle != 0 { //not completed
							//angle += sin(life * pi*2) * angle_wiggle * 0.5;
							
							//EaseLinear(inputvalue,outputmin,outputmax,inputmax)
							//var ang = argument2 * argument0 / argument3 + argument1;
						}
						
						//Changing size (size_increase)
						if size_increase != 0 {
							x_size += size_increase * part_system_delta;
							y_size += size_increase * part_system_delta;
							if (x_size <= 0 or y_size <= 0) { life = 0; }
						}
						
						//Step particles // NOT COMPLETED! //
						if part_type.part_step_number != 0 {
							//Burst particles with deltatime (create numbers of particles within a second) if ps.part_system_deltatime == true
							//And burst particles without deltatime (create numbers of particles each step) if ps.part_system_deltatime == false
							var spawn_interval = 1 / part_type.part_step_number;
							if (other.part_system_deltatime == true) part_type.spawn_timer += global.dt_steady;
							var repeat_count = other.part_system_deltatime ? floor(part_type.spawn_timer / spawn_interval) : part_type.part_step_number;
	
							repeat(repeat_count) {
								var part = new particle(part_type.part_step_type);
								with(part) {
									x = other.x;
									y = other.y;
								}
								ds_list_add(other.particle_list, part);
								part_type.spawn_timer = part_type.spawn_timer mod spawn_interval;
							}
						}
						
						//Destroy particles
						if life <= 0 {
							if death_part != noone {
								var part = new particle(death_part);
								with(part) {
									emitter = other.emitter;
									x = other.x;
									y = other.y;
								}
								ds_list_replace(other.particle_list, i, part);
								repeat(death_number-1) {
									var part = new particle(death_part);
									with(part) {
										emitter = other.emitter;
										x = other.x;
										y = other.y;
									}
									ds_list_add(other.particle_list, part);
								}
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
				if is_struct(particle) {
					//draw every particle if it is in view
					//if get_view(particle.x, particle.y, particle.part_width, particle.part_height)
					with(particle) {
						
						if sprite == noone or alpha == 0 break;
						
						if additiveblend gpu_set_blendmode(bm_add); //TEMPORARY
						
						if (x_size == 1 && y_size == 1 && angle == 0 && color == c_white && alpha == 1) {
							draw_sprite(sprite, subimg, x-part_width_half, y-part_height_half);
						} else {
							draw_sprite_ext(sprite, subimg, x-part_width_half, y-part_height_half, x_size, y_size, angle, color, alpha);
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
	self.part_type = part_type;
	
	sprite = part_type.part_sprite;
	subimg = part_type.part_subimg; if (part_type.part_subimg_random) subimg = irandom(sprite_get_number(sprite) - 1);
	life = random_range(part_type.part_time_min,part_type.part_time_max);
	life_max = life;
	
	x = 0;
	y = 0;
	direction = random_range(part_type.part_direction_min,part_type.part_direction_max);
	direction_increase = part_type.part_direction_increase;
	direction_wiggle = part_type.part_direction_wiggle;
	speed = max(0, random_range(part_type.part_speed_min,part_type.part_speed_max));
	speed_increase = part_type.part_speed_increase;
	speed_wiggle = part_type.part_speed_wiggle;
	gravity = 0;
	gravity_direction = part_type.part_gravity_direction;
	gravity_speed = part_type.part_gravity_speed;
	point_gravity = 0;
	point_gravity_x = part_type.part_point_gravity_x;
	point_gravity_y = part_type.part_point_gravity_y;
	point_gravity_speed = part_type.part_point_gravity_speed;
	
	x_size = random_range(part_type.part_size_min,part_type.part_size_max);
	y_size = x_size;
	size_increase = part_type.part_size_increase;
	size_wiggle = part_type.part_size_wiggle;
	x_size *= part_type.part_xscale;
	y_size *= part_type.part_yscale;
	part_width = part_type.part_sprite_width * x_size;
	part_height = part_type.part_sprite_height * y_size;
	part_width_half = part_width / 2;
	part_height_half = part_height / 2;
	
	angle = random_range(part_type.part_angle_min,part_type.part_angle_max);
	angle_increase = part_type.part_angle_increase;
	angle_wiggle = part_type.part_angle_wiggle;
	angle_relative = part_type.part_angle_relative;
	
	color = part_type.part_color;
	alpha = 1;
		
	self.colors_enabled = part_type.colors_enabled;
	if colors_enabled {
		self.color1 = part_type.part_color_1;
		self.color2 = part_type.part_color_2;
		self.color3 = part_type.part_color_3;
		color = color1;
	}
		
	self.alpha_blend_enabled = part_type.alpha_blend_enabled;
	if alpha_blend_enabled {
		self.alpha1 = part_type.part_alpha_1;
		self.alpha2 = part_type.part_alpha_2;
		self.alpha3 = part_type.part_alpha_3;
		alpha = alpha1;
	}
		
	self.additiveblend = part_type.part_additiveblend;
		
	death_part = part_type.part_death_type;
	death_number = part_type.part_death_number;
}

function advanced_part_emitter(ps, xmin, xmax, ymin, ymax, shape, distribution) constructor {
	part_sys = ps;
	
	x_left = xmin;
	x_right = xmax;
	y_top = ymin;
	y_down = ymax;
	
	emitter_shape = shape;
	emitter_distr = distribution;
}

function advanced_part_type() constructor {
	part_sprite = noone;
	part_subimg = 0;
	part_color = c_white;
	part_animate = false;
	part_stretch = false;
	part_subimg_random = false;
	
	colors_enabled = false;
	part_color_1 = c_white;
	part_color_2 = c_white;
	part_color_3 = c_white;
	
	alpha_blend_enabled = false;
	part_alpha_1 = c_white;
	part_alpha_2 = c_white;
	part_alpha_3 = c_white;
	
	part_additiveblend = false;
	
	part_time_min = room_speed;
	part_time_max = room_speed*2;
	
	part_size_min = 1;
	part_size_max = 1;
	part_size_increase = 0;
	part_size_wiggle = 0;
	part_xscale = 1;
	part_yscale = 1;
	
	part_angle_min = 0;
	part_angle_max = 0;
	part_angle_increase = 0;
	part_angle_wiggle = 0;
	part_angle_relative = false;
	
	part_sprite_width = sprite_get_width(part_sprite);
	part_sprite_height = sprite_get_height(part_sprite);
	
	part_speed_min = 0;
	part_speed_max = 0;
	part_speed_increase = 0;
	part_speed_wiggle = 0;
	
	part_direction_min = 0;
	part_direction_max = 0;
	part_direction_increase = 0;
	part_direction_wiggle = 0;
	
	part_gravity_direction = 0;
	part_gravity_speed = 0;
	
	part_point_gravity_x = 0;
	part_point_gravity_y = 0;
	part_point_gravity_speed = 0;
	
	part_death_number = 0;
	part_death_type = noone;
	
	part_step_number = 0;
	part_step_type = noone;
	
	spawn_timer = 0;
	
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
		self.part_color_1 = color1;
		self.part_color_2 = color2;
		self.part_color_3 = color3;
	}
	
	function part_alpha3(alpha1, alpha2, alpha3) {
		self.alpha_blend_enabled = true;
		self.part_alpha_1 = alpha1;
		self.part_alpha_2 = alpha2;
		self.part_alpha_3 = alpha3;
	}
	
	function part_blend(additive) {
		self.part_additiveblend = additive;
	}
	
	function part_size(size_min, size_max, size_incr, size_wiggle) {
		self.part_size_min = size_min;
		self.part_size_max = size_max;
		self.part_size_increase = size_incr;
		self.part_size_wiggle = size_wiggle;
	}
	
	function part_scale(xscale, yscale) {
		self.part_xscale = xscale;
		self.part_yscale = yscale;
	}
	
	function part_orientation(ang_min, ang_max, ang_incr, ang_wiggle, ang_relative) {
		self.part_angle_min = ang_min;
		self.part_angle_max = ang_max;
		self.part_angle_increase = ang_incr;
		self.part_angle_wiggle = ang_wiggle;
		self.part_angle_relative = ang_relative;
	}
	
	function part_life(life_min, life_max) {
		self.part_time_min = life_min;
		self.part_time_max = life_max;
	}
	
	function part_gravity(gravity_amount, gravity_dir) {
		self.part_gravity_speed = gravity_amount;
		self.part_gravity_direction = gravity_dir;
	}
	
	function part_point_gravity(point_gravity_amount, point_gravity_x, point_gravity_y) {
		self.part_point_gravity_speed = point_gravity_amount;
		self.part_point_gravity_x = point_gravity_x;
		self.part_point_gravity_y = point_gravity_y;
	}
	
	function part_speed(speed_min, speed_max, speed_incr, speed_wiggle) {
		self.part_speed_min = speed_min;
		self.part_speed_max = speed_max;
		self.part_speed_increase = speed_incr;
		self.part_speed_wiggle = speed_wiggle;
	}
	
	function part_direction(dir_min, dir_max, dir_incr, dir_wiggle) {
		self.part_direction_min = dir_min;
		self.part_direction_max = dir_max;
		self.part_direction_increase = dir_incr;
		self.part_direction_wiggle = dir_wiggle;
	}
	
	function part_step(step_number, step_type) {
		self.part_step_number = step_number;
		self.part_step_type = step_type;
	}
	
	function part_death(death_number, death_type) {
		self.part_death_number = death_number;
		self.part_death_type = death_type;
	}
}

function advanced_part_emitter_burst(ps, part_emit, part_type, number) {
	// WITH DELTATIME		// Burst particles with deltatime (create numbers of particles within a second)
	// WITHOUT DELTATIME	// And burst particles without deltatime (create numbers of particles each step)
	var spawn_interval = 1 / number;
	if (ps.part_system_deltatime == true) part_type.spawn_timer += global.dt_steady;
	var repeat_count = ps.part_system_deltatime ? floor(part_type.spawn_timer / spawn_interval) : number;
	
	repeat(repeat_count) {
		var part = new particle(part_type);
		with(part) {
			emitter = part_emit;
			switch(emitter.emitter_shape) {
				default:
				case aps_shape.rectangle: 
					x = random_range(emitter.x_left, emitter.x_right);
					y = random_range(emitter.y_top, emitter.y_down);
				break; 
				case aps_shape.ellipse:
					var A = (emitter.x_right - emitter.x_left) / 2;
					var B = (emitter.y_down - emitter.y_top) / 2;
					var X = random_range(-A, A);
					var Y = sqrt(B*B * (1 - X*X / (A*A)));
					x = X + emitter.x_left + A;
					y = random_range(-Y, Y) + emitter.y_top + B;
				break;
				case aps_shape.line:
					var A = (emitter.x_right - emitter.x_left) / 2;
					var B = (emitter.y_down - emitter.y_top) / 2;
					var X = random_range(-A, A);
					x = X + emitter.x_left + A;
					y = X / ((emitter.x_right - emitter.x_left) / (emitter.y_down - emitter.y_top)) + emitter.y_top + B;
				break; 
			}
		}
		ds_list_add(ps.particle_list, part);
	}
	
	part_type.spawn_timer = part_type.spawn_timer mod spawn_interval;
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

function advanced_part_emitter_region(part_emit, xmin, xmax, ymin, ymax, shape, distribution) {
	with(part_emit) {
		x_left = xmin;
		y_top = ymin;
		x_right = xmax;
		y_down = ymax;
		
		emitter_shape = shape;
		emitter_distr = distribution;
	}
}

function advanced_part_system_destroy(id) {
	with(id) ds_list_destroy(particle_list);
	delete id;
}