//Advanced particle system by Limekys (This script has MIT Licence)
#macro LIMEKYS_ADVANCED_PARTICLE_SYSTEM_VERSION "2023.10.17"

#macro _APS_DT global.particle_system_deltatime //This is a delta time variable, you can replace it with your own if you use your delta time system in the game

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
	
	particle_array = [];
	emitters_array = [];
	part_system_max_count = 1000;
	part_system_debug_mode = false;
	
	//update_interval = aps_update_interval; //not completed
	
	//DELTATIME SYSTEM INIT
	part_system_deltatime_is_enabled = false;
	
	//Actual deltatime variable
	global.particle_system_deltatime = 0;
	// The lowest required frame rate before delta time will lag behind Step update.
	// Setting this too low can increase chance of sporadic behaviour.
	// Setting too high can cause games to lag behind during heavy cpu/gpu load.
	minFPS = 10; // Default: 10 -- Not too hot, not too cold, but just right
	
	// The scale factor to multiply with delta time.
	// Can be used to create global slow/fast motion affects.
	// Negative values can be used, but are not advised under normal circumstances.
	scale = 1.0; // Default: 1.0 -- Set higher to increase speed and lower to decrease speed
	
	// Internal calculated delta time
	dt = delta_time/1000000;
	// Previous value of internal delta time
	dtPrevious = dt;
	// Whether or not internal delta time has been restored to previous value
	dtRestored = false;
	
	///@func enabledelta(enable = true)
	///@desc Turns on the delta variable based on time
	static enabledelta = function(enable = true) {
		part_system_deltatime_is_enabled = enable;
		return self;
	}
	
	///@func set_max_count(max_count = 1000)
	///@desc Set max count of all particles
	static set_max_count = function(max_count = 1000) {
		part_system_max_count = max_count;
		return self;
	}
	
	///@func clear()
	///@desc Delete all exists particles
	static clear = function() {
		particle_array = [];
	}
	
	//Particles updating
	///@func step()
	///@desc Updating all particles
	static step = function() {
		
		//if (update_interval < aps_update_interval) { update_interval++; } else { update_interval = 1; } //not completed
		
		//DELTATIME SYSTEM UPDATE
		if part_system_deltatime_is_enabled {
			// Store previous internal delta time
			dtPrevious = dt;
			// Update internal delta time
			dt = delta_time/1000000;
			// Prevent delta time from exhibiting sporadic behaviour
			if (dt > 1/minFPS) {
				if (dtRestored) { 
					dt = 1/minFPS; 
				} else { 
					dt = dtPrevious;
					dtRestored = true;
				}
			} else {
				dtRestored = false;
			}
			// Assign internal delta time to global delta time affected by the time scale
			global.particle_system_deltatime = dt*scale;
		}
		
		//Update particles
		var _length = array_length(particle_array);
		
		if _length > 0 {
			
			//Remove unnecessary particles if the number of particles exceeds a given maximum value in "part_system_max_count"
			if _length > part_system_max_count {
				var _unnecessary_particles_number = _length - part_system_max_count;
				repeat(_unnecessary_particles_number) {
					//Select a random particle
					var _part = irandom(_length--);
					//And delete it
					array_delete(particle_array, _part, 1);
				}
			}
			
			//Update all particles
			var _delta_time = part_system_deltatime_is_enabled ? _APS_DT : 1;
			var i = _length - 1;
			repeat (_length) {
				var _particle = particle_array[i];
				if is_struct(_particle) {
					//Update every particle
					with(_particle) {
						
						//Moving
						var _x_speed = dcos(direction) * speed * _delta_time;
						var _y_speed = -dsin(direction) * speed * _delta_time;
						
						if gravity_speed != 0 {
							gravity += gravity_speed * _delta_time;
							_x_speed += dcos(gravity_direction) * gravity * _delta_time;
							_y_speed += -dsin(gravity_direction) * gravity * _delta_time;
						}
						if point_gravity_speed != 0 {
							point_gravity += point_gravity_speed * _delta_time;
							var point_gravity_dir = point_direction(x, y, point_gravity_x, point_gravity_y);
							_x_speed += dcos(point_gravity_dir) * point_gravity * _delta_time;
							_y_speed += -dsin(point_gravity_dir) * point_gravity * _delta_time;
						}
						
						x_previous = x;
						y_previous = y;
						
						x += _x_speed;
						y += _y_speed;
						
						life -= _delta_time;
						
						//Custom step function
						if is_method(step_function) {
							step_function();
						}
						
						//Changing color
						if colors_enabled {
							var _percent = 1 - (life / life_max);
							
							if _percent <= 0.5 {
								color = merge_colour(color1, color2, _percent * 2);
							} else {
								color = merge_colour(color2, color3, _percent * 2 - 1);
							}
						}
						
						//Changing alpha
						if alpha_blend_enabled {
							var _percent = 1 - (life / life_max);
							
							if _percent <= 0.5 {
								alpha = lerp(alpha1, alpha2, _percent * 2);
							} else {
								alpha = lerp(alpha2, alpha3, _percent * 2 - 1);
							}
						}
						
						//Changing direction (direction_increase)
						if direction_increase != 0 {
							direction += direction_increase * _delta_time;
						}
						if direction_wiggle != 0 { //???//
							var _wiggle = direction_wiggle;
							direction = direction + wiggle(-_wiggle, _wiggle, 0.2 * _delta_time, life);
						}
						
						//Changing speed (speed_increase)
						if speed_increase != 0 && speed > 0 {
							speed += speed_increase * _delta_time;
						}
						if speed_wiggle != 0 && speed > 0 { //???//
							var _wiggle = speed_wiggle;
							speed = speed + wiggle(-_wiggle, _wiggle, 0.2 * _delta_time, life);
						}
						
						//Changing angle (angle_increase, angle_relative)
						if angle_relative {
							angle = direction;
						} else if angle_increase != 0 {
							angle += angle_increase * _delta_time;
						}
						if angle_wiggle != 0 { //???//
							var _wiggle = angle_wiggle;
							angle = angle + wiggle(-_wiggle, _wiggle, 0.2 * _delta_time, life);
						}
						
						//Changing size (size_increase)
						if size_increase != 0 {
							x_size += size_increase * _delta_time;
							y_size += size_increase * _delta_time;
							if (x_size <= 0 || y_size <= 0) { life = 0; }
						}
						if size_wiggle != 0 { //???//
							var _wiggle = size_wiggle;
							x_size = x_size + wiggle(-_wiggle, _wiggle, 0.2 * _delta_time, life);
							y_size = y_size + wiggle(-_wiggle, _wiggle, 0.2 * _delta_time, life);
						}
						
						//Step particles // NOT COMPLETED! //
						if part_type.part_step_number != 0 {
							//Burst particles with deltatime (create numbers of particles within a second) if ps.part_system_deltatime_is_enabled == true
							//And burst particles without deltatime (create numbers of particles each step) if ps.part_system_deltatime_is_enabled == false
							var _spawn_interval = 1 / part_type.part_step_number;
							if (other.part_system_deltatime_is_enabled == true) part_type.spawn_timer += _APS_DT;
							var _count = other.part_system_deltatime_is_enabled ? floor(part_type.spawn_timer / _spawn_interval) : part_type.part_step_number;

							repeat (_count) {
								var _step_particle = new particle(part_type.part_step_type);
								with(_step_particle) {
									x = other.x;
									y = other.y;
								}
								array_push(other.particle_array, _step_particle);
								part_type.spawn_timer = part_type.spawn_timer mod _spawn_interval;
							}
						}
						
						//Destroy particles
						if life <= 0 {
							if death_part != undefined {
								var _death_particle = new particle(death_part);
								with(_death_particle) {
									emitter = other.emitter;
									x = other.x;
									y = other.y;
								}
								other.particle_array[i] = _death_particle;
								repeat (death_number - 1) {
									_death_particle = new particle(death_part);
									with(_death_particle) {
										emitter = other.emitter;
										x = other.x;
										y = other.y;
									}
									array_push(other.particle_array, _death_particle);
								}
							} else {
								array_delete(other.particle_array, i, 1);
							}
						}
					}
				}
				--i;
			}
		}
	}
	
	//Particles drawing
	///@func draw()
	///@desc Render all particles
	static draw = function() {
		if array_length(particle_array) > 0 {
			var _length = array_length(particle_array);
			var i = 0;
			repeat (_length) {
				var _particle = particle_array[i];
				if is_struct(_particle) {
					with(_particle) {
						
						if sprite == undefined || alpha == 0 break;
						
						if additiveblend gpu_set_blendmode(bm_add); //TEMPORARY
						
						if (x_size == 1 && y_size == 1 && angle == 0 && color == c_white && alpha == 1) {
							draw_sprite(sprite, subimg, x, y);
						} else {
							draw_sprite_ext(sprite, subimg, x, y, x_size, y_size, angle, color, alpha);
						}
						
						if additiveblend gpu_set_blendmode(bm_normal); //TEMPORARY
					}
				}
				++i;
			}
		}
		
		//Draw debug info
		if part_system_debug_mode && array_length(emitters_array) > 0 {
			var _def_col = draw_get_color();
			var _def_alp = draw_get_alpha();
			draw_set_color(c_red);
			draw_set_alpha(0.5);
			var _length = array_length(emitters_array);
			var i = 0;
			repeat (_length) {
				var _emitter = emitters_array[i];
				if is_struct(_emitter) {
					with(_emitter) {
						draw_rectangle(x_left, y_top, x_right, y_down, true);
						draw_line(x_left - 1, y_top - 1, x_right, y_down);
						draw_line(x_left - 1, y_down, x_right, y_top - 1);
					}
				}
				++i;
			}
			draw_set_color(_def_col);
			draw_set_alpha(_def_alp);
		}
	}
}

//Particle type
function advanced_part_type() constructor {
	self.part_sprite = undefined;
	self.part_subimg = 0;
	self.part_color = c_white;
	self.part_animate = false;
	self.part_stretch = false;
	self.part_subimg_random = false;
	
	self.colors_enabled = false;
	self.part_color_1 = c_white;
	self.part_color_2 = c_white;
	self.part_color_3 = c_white;
	
	self.alpha_blend_enabled = false;
	self.part_alpha_1 = c_white;
	self.part_alpha_2 = c_white;
	self.part_alpha_3 = c_white;
	
	self.part_additiveblend = false;
	
	self.part_time_min = 60;
	self.part_time_max = 120;
	
	self.part_size_min = 1;
	self.part_size_max = 1;
	self.part_size_increase = 0;
	self.part_size_wiggle = 0;
	self.part_xscale = 1;
	self.part_yscale = 1;
	
	self.part_angle_min = 0;
	self.part_angle_max = 0;
	self.part_angle_increase = 0;
	self.part_angle_wiggle = 0;
	self.part_angle_relative = false;
	
	self.part_speed_min = 0;
	self.part_speed_max = 0;
	self.part_speed_increase = 0;
	self.part_speed_wiggle = 0;
	
	self.part_direction_min = 0;
	self.part_direction_max = 0;
	self.part_direction_increase = 0;
	self.part_direction_wiggle = 0;
	
	self.part_gravity_direction = 0;
	self.part_gravity_speed = 0;
	
	self.part_point_gravity_x = 0;
	self.part_point_gravity_y = 0;
	self.part_point_gravity_speed = 0;
	
	self.part_death_number = 0;
	self.part_death_type = undefined;
	
	self.part_step_number = 0;
	self.part_step_type = undefined;
	
	self.spawn_timer = 0;
	
	self.part_step_func = -1;
	
	///@func part_image(sprite, subimg, color, animate, stretch, is_random)
	static part_image = function(sprite, subimg, color, animate, stretch, is_random) {
		self.part_sprite = sprite;
		self.part_subimg = subimg;
		self.part_color = color;
		self.part_animate = animate;
		self.part_stretch = stretch;
		self.part_subimg_random = is_random;
		return self;
	}
	
	///@func part_color3(color1, color2, color3)
	static part_color3 = function(color1, color2, color3) {
		self.colors_enabled = true;
		self.part_color_1 = color1;
		self.part_color_2 = color2;
		self.part_color_3 = color3;
		return self;
	}
	
	///@func part_alpha3(alpha1, alpha2, alpha3)
	static part_alpha3 = function(alpha1, alpha2, alpha3) {
		self.alpha_blend_enabled = true;
		self.part_alpha_1 = alpha1;
		self.part_alpha_2 = alpha2;
		self.part_alpha_3 = alpha3;
		return self;
	}
	
	///@func part_blend(additive)
	static part_blend = function(additive) {
		self.part_additiveblend = additive;
		return self;
	}
	
	///@func part_size(size_min, size_max, size_incr, size_wiggle)
	static part_size = function(size_min, size_max, size_incr, size_wiggle) {
		self.part_size_min = size_min;
		self.part_size_max = size_max;
		self.part_size_increase = size_incr;
		self.part_size_wiggle = size_wiggle;
		return self;
	}
	
	///@func part_scale(xscale, yscale)
	static part_scale = function(xscale, yscale) {
		self.part_xscale = xscale;
		self.part_yscale = yscale;
		return self;
	}
	
	///@func part_orientation(ang_min, ang_max, ang_incr, ang_wiggle, ang_relative)
	static part_orientation = function(ang_min, ang_max, ang_incr, ang_wiggle, ang_relative) {
		self.part_angle_min = ang_min;
		self.part_angle_max = ang_max;
		self.part_angle_increase = ang_incr;
		self.part_angle_wiggle = ang_wiggle;
		self.part_angle_relative = ang_relative;
		return self;
	}
	
	///@func part_life(life_min, life_max)
	static part_life = function(life_min, life_max) {
		self.part_time_min = life_min;
		self.part_time_max = life_max;
		return self;
	}
	
	///@func part_gravity(gravity_amount, gravity_dir)
	static part_gravity = function(gravity_amount, gravity_dir) {
		self.part_gravity_speed = gravity_amount;
		self.part_gravity_direction = gravity_dir;
		return self;
	}
	
	///@func part_point_gravity(point_gravity_amount, point_gravity_x, point_gravity_y)
	static part_point_gravity = function(point_gravity_amount, point_gravity_x, point_gravity_y) {
		self.part_point_gravity_speed = point_gravity_amount;
		self.part_point_gravity_x = point_gravity_x;
		self.part_point_gravity_y = point_gravity_y;
		return self;
	}
	
	///@func part_speed(speed_min, speed_max, speed_incr, speed_wiggle)
	static part_speed = function(speed_min, speed_max, speed_incr, speed_wiggle) {
		self.part_speed_min = speed_min;
		self.part_speed_max = speed_max;
		self.part_speed_increase = speed_incr;
		self.part_speed_wiggle = speed_wiggle;
		return self;
	}
	
	///@func part_direction(dir_min, dir_max, dir_incr, dir_wiggle)
	static part_direction = function(dir_min, dir_max, dir_incr, dir_wiggle) {
		self.part_direction_min = dir_min;
		self.part_direction_max = dir_max;
		self.part_direction_increase = dir_incr;
		self.part_direction_wiggle = dir_wiggle;
		return self;
	}
	
	///@func part_step(step_number, step_type)
	static part_step = function(step_number, step_type) {
		self.part_step_number = step_number;
		self.part_step_type = step_type;
		return self;
	}
	
	///@func part_death(death_number, death_type)
	static part_death = function(death_number, death_type) {
		self.part_death_number = death_number;
		self.part_death_type = death_type;
		return self;
	}
	
	///@func part_step_function(_function)
	static part_step_function = function(_function) {
		self.part_step_func = _function;
		return self;
	}
}

//Particle
function particle(part_type) constructor {
	self.emitter = undefined;
	self.part_type = part_type;
	
	self.sprite = part_type.part_sprite;
	self.subimg = part_type.part_subimg; if (part_type.part_subimg_random) subimg = irandom(sprite_get_number(sprite) - 1);
	self.life = random_range(part_type.part_time_min,part_type.part_time_max);
	self.life_max = life;
	
	self.x = 0;
	self.y = 0;
	self.x_previous = self.x;
	self.y_previous = self.y;
	self.direction = random_range(part_type.part_direction_min,part_type.part_direction_max);
	self.direction_increase = part_type.part_direction_increase;
	self.direction_wiggle = part_type.part_direction_wiggle;
	self.speed = max(0, random_range(part_type.part_speed_min,part_type.part_speed_max));
	self.speed_increase = part_type.part_speed_increase;
	self.speed_wiggle = part_type.part_speed_wiggle;
	self.gravity = 0;
	self.gravity_direction = part_type.part_gravity_direction;
	self.gravity_speed = part_type.part_gravity_speed;
	self.point_gravity = 0;
	self.point_gravity_x = part_type.part_point_gravity_x;
	self.point_gravity_y = part_type.part_point_gravity_y;
	self.point_gravity_speed = part_type.part_point_gravity_speed;
	
	self.x_size = random_range(part_type.part_size_min,part_type.part_size_max);
	self.y_size = x_size;
	self.size_increase = part_type.part_size_increase;
	self.size_wiggle = part_type.part_size_wiggle;
	self.x_size *= part_type.part_xscale;
	self.y_size *= part_type.part_yscale;
	
	self.angle = random_range(part_type.part_angle_min,part_type.part_angle_max);
	self.angle_increase = part_type.part_angle_increase;
	self.angle_wiggle = part_type.part_angle_wiggle;
	self.angle_relative = part_type.part_angle_relative;
	
	self.color = part_type.part_color;
	self.alpha = 1;
		
	self.colors_enabled = part_type.colors_enabled;
	if colors_enabled {
		self.color1 = part_type.part_color_1;
		self.color2 = part_type.part_color_2;
		self.color3 = part_type.part_color_3;
		color = color1;
	}
		
	self.alpha_blend_enabled = part_type.alpha_blend_enabled;
	if self.alpha_blend_enabled {
		self.alpha1 = part_type.part_alpha_1;
		self.alpha2 = part_type.part_alpha_2;
		self.alpha3 = part_type.part_alpha_3;
		self.alpha = alpha1;
	}
		
	self.additiveblend = part_type.part_additiveblend;
		
	self.death_part = part_type.part_death_type;
	self.death_number = part_type.part_death_number;
	
	self.step_function = is_method(part_type.part_step_func) ? method(self, part_type.part_step_func) : undefined;
	
	///@func wiggle(_from, _dest, _duration, _offset)
	///@desc wiggle particle (this function used only on Particle!
	static wiggle = function(_from, _dest, _duration, _offset) {
		var a4 = (_dest - _from) * 0.5;
		return _from + a4 + sin((((current_time * 0.001) + _duration * _offset) / _duration) * (pi*2)) * a4;
	}
}

//Emitters
function advanced_part_emitter(ps, xmin, xmax, ymin, ymax, shape, distribution) constructor {
	self.part_sys = ps;
	self.x_left = xmin;
	self.x_right = xmax;
	self.y_top = ymin;
	self.y_down = ymax;
	self.emitter_shape = shape;
	self.emitter_distr = distribution;
	array_push(ps.emitters_array, self);
}

function advanced_part_emitter_region(part_emit, xmin, xmax, ymin, ymax, shape, distribution) {
	with(part_emit) {
		self.x_left = xmin;
		self.y_top = ymin;
		self.x_right = xmax;
		self.y_down = ymax;
		self.emitter_shape = shape;
		self.emitter_distr = distribution;
	}
}

///@desc Creates the specified number of particles from the emitter within a second/step,
///	and returns an array with the currently created particles;
/// If DeltaTime enabled: Create numbers of particles within a second;
/// If DeltaTime disabled: Create numbers of particles each step.
function advanced_part_emitter_burst(ps, part_emit, part_type, number, spawn_timer = "emitter_burst") {
	//Create a unique variable for the particle creation timer
	//(in case this function will be called several times in the same object)
	if !variable_instance_exists(self, spawn_timer) {
		variable_instance_set(self, spawn_timer, 0);
	}
	//Calculate spawn interval
	var spawn_interval = 1 / number;
	//Counting the timer if DeltaTime is enabled
	if (ps.part_system_deltatime_is_enabled == true) {
		self[$ spawn_timer] = self[$ spawn_timer] + _APS_DT;
	}
	//Calculate the number of particles
	var count = ps.part_system_deltatime_is_enabled ? floor(self[$ spawn_timer] / spawn_interval) : number;
	//Create particles
	var _particles = [];
	repeat (count) {
		var _particle = new particle(part_type);
		with(_particle) {
			emitter = part_emit;
			var A = 0, B = 0, X = 0, Y = 0;
			switch(emitter.emitter_shape) {
				default:
				case aps_shape.rectangle: 
					x = random_range(emitter.x_left, emitter.x_right);
					y = random_range(emitter.y_top, emitter.y_down);
				break; 
				case aps_shape.ellipse:
					A = (emitter.x_right - emitter.x_left) / 2;
					B = (emitter.y_down - emitter.y_top) / 2;
					X = random_range(-A, A);
					if (A == 0) {A = 1;}
					Y = sqrt(B*B * (1 - X*X / (A*A)));
					x = X + emitter.x_left + A;
					y = random_range(-Y, Y) + emitter.y_top + B;
				break;
				case aps_shape.line:
					A = (emitter.x_right - emitter.x_left) / 2;
					B = (emitter.y_down - emitter.y_top) / 2;
					X = random_range(-A, A);
					x = X + emitter.x_left + A;
					y = X / ((emitter.x_right - emitter.x_left) / (emitter.y_down - emitter.y_top)) + emitter.y_top + B;
				break; 
			}
		}
		array_push(ps.particle_array, _particle);
		array_push(_particles, _particle);
	}
	//Reset timer
	self[$ spawn_timer] = self[$ spawn_timer] mod spawn_interval;
	//Return array with created particles in this step
	return _particles;
}

///@desc Creates particles and return array with created particles
function advanced_part_particles_create(ps, x, y, part_type, number) {
	var _particles = [];
	repeat (number) {
		var _particle = new particle(part_type);
		with(_particle) {
			self.x = x;
			self.y = y;
		}
		array_push(ps.particle_array, _particle);
		array_push(_particles, _particle);
	}
	return _particles;
}

///@desc Creates the specified number of particles at X,Y position within a second/step,
///	and returns an array with the currently created particles;
/// If DeltaTime enabled: Create numbers of particles within a second;
/// If DeltaTime disabled: Create numbers of particles each step.
function advanced_part_particles_burst(ps, x, y, part_type, number, spawn_timer = "particles_burst") {
	//Create a unique variable for the particle creation timer
	//(in case this function will be called several times in the same object)
	if !variable_instance_exists(self, spawn_timer) {
		variable_instance_set(self, spawn_timer, 0);
	}
	//Calculate spawn interval
	var spawn_interval = 1 / number;
	//Counting the timer if DeltaTime is enabled
	if (ps.part_system_deltatime_is_enabled == true) {
		self[$ spawn_timer] = self[$ spawn_timer] + _APS_DT;
	}
	//Calculate the number of particles
	var count = ps.part_system_deltatime_is_enabled ? floor(self[$ spawn_timer] / spawn_interval) : number;
	//Create particles
	var _particles = [];
	repeat (count) {
		var _particle = new particle(part_type);
		with(_particle) {
			self.x = x;
			self.y = y;
		}
		array_push(ps.particle_array, _particle);
		array_push(_particles, _particle);
	}
	//Reset timer
	self[$ spawn_timer] = self[$ spawn_timer] mod spawn_interval;
	//Return array with created particles in this step
	return _particles;
}