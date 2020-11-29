function advanced_part_system() constructor {
	particle_list = ds_list_create();
	
	function step() {
		if !ds_list_empty(particle_list) {
			var _size = ds_list_size(particle_list);
			for (var i = 0; i < _size; i++) {
				var particle = ds_list_find_value(particle_list, i);
				if particle {
					//update every particle
					with(particle) {
						var gravity_dir = point_direction(x, y, emiter_.point_gravity_x, emiter_.point_gravity_y);
						var x_speed = lengthdir_x(speed,direction)+lengthdir_x(gravity_num,gravity_direction)+lengthdir_x(point_gravity_num,gravity_dir);
						var y_speed = lengthdir_y(speed,direction)+lengthdir_y(gravity_num,gravity_direction)+lengthdir_y(point_gravity_num,gravity_dir);
						var speed_ = point_distance(0,0,x_speed,y_speed);
						var dir = point_direction(0,0,x_speed,y_speed);
						x += x_speed;
						y += y_speed;
						speed = speed_;
						direction = dir;
						life--;
			
						//destroy particles
						if life <= 0 {
							if dead_part {
								var part = advanced_part_burst(other, emiter_, dead_part);
								part.x = x;
								part.y = y;
								ds_list_replace(other.particle_list, ds_list_size(other.particle_list)-1, part);
							}
							ds_list_delete(other.particle_list, i);
						}
					}
				}
			}
		}
	}
	
	function draw() {
		if !ds_list_empty(particle_list) {
			var _size = ds_list_size(particle_list);
			for (var i = 0; i < _size; i++) {
				var particle = ds_list_find_value(particle_list, i);
				if particle {
					//draw every particle
					with(particle) {
						if (x_scale == 1 && x_scale == y_scale && angle == 0 && color == c_white && alpha == 1) {
							draw_sprite(sprite, 0, x, y);
						} else {
							draw_sprite_ext(sprite, 0, x, y, x_scale, y_scale, angle, color, alpha);
						}
					}
				}
			}
		}
	}
}

function advanced_part_emitter(ps, x1, y1, x2, y2, num_spawn, spawn_speed, gravity_point_x, gravity_point_y) constructor {
	part_sys = ps;
	
	x_left = x1;
	y_top = y1;
	x_right = x2;
	y_down = y2;
	spawn_num = num_spawn;
	spawn_speed_ = spawn_speed;
	
	point_gravity_x = gravity_point_x;
	point_gravity_y = gravity_point_y;
	
	function particle(part_) constructor {
		emiter_ = other;
		x = random_range(emiter_.x_left,emiter_.x_right);
		y = random_range(emiter_.y_top,emiter_.y_down);
		color = part_.part_color;
		alpha = 1;
		sprite = part_.part_sprite;
		angle = random_range(part_.angle_min,part_.angle_max);
		life = irandom_range(part_.part_time_min,part_.part_time_max);
		x_scale = random_range(part_.part_xscale_min,part_.part_xscale_max);
		dead_part = part_.part_dead;
		if part_.part_scale_equal {
			y_scale = x_scale;
		} else {
			y_scale = random_range(part_.part_yscale_min,part_.part_yscale_max);
		}
		direction = random_range(part_.part_direction_min,part_.part_direction_max);
		speed = random_range(part_.part_speed_min,part_.part_speed_max);
		gravity_direction = part_.part_gravity_direction;
		gravity_num = part_.part_gravity_direction_num;
		point_gravity_num = part_.part_gravity_point_num;
	}
}

function advanced_part_type() constructor {
	part_sprite = s_pixel;
	part_color = c_white;
	angle_min = 0;
	angle_max = 359;
	part_time_min = 60;
	part_time_max = 90;
	part_xscale_min = 1;
	part_xscale_max = 1;
	part_scale_equal = true;
	part_yscale_min = 1;
	part_yscale_max = 1;
	
	part_direction_min = 0;
	part_direction_max = 359;
	part_speed_min = 1;
	part_speed_max = 2;
	
	part_gravity_direction_num = 0;
	part_gravity_direction = 0;
	
	part_point_gravity_num = 0;
	
	part_dead = noone;
	
	function part_gravity(gravity_dir,gravity_num,point_gravity_num){
		self.part_gravity_direction = gravity_dir;
		self.part_gravity_direction_num = gravity_num;
		self.part_gravity_point_num = point_gravity_num;
	}
	
	function part_life(life_min,life_max){
		self.part_time_min = life_min;
		self.part_time_max = life_max;
	}
	
	function part_transform(angle_min_,angle_max_,x_scale_min,x_scale_max,y_scale_min,y_scale_max,scale_equal){
		self.angle_min = angle_min_;
		self.angle_max = angle_max_;
		self.part_xscale_min = x_scale_min;
		self.part_xscale_max = x_scale_max;
		self.part_scale_equal = scale_equal;
		self.part_yscale_min = y_scale_min;
		self.part_yscale_max = y_scale_max;
	}
	
	function part_image(sprite_,color_){
		self.part_sprite = sprite_;
		self.part_color = color_;
	}
	
	function part_move(direction_min,direction_max,speed_min,speed_max){
		self.part_direction_min = direction_min;
		self.part_direction_max = direction_max;
		self.part_speed_min = speed_min;
		self.part_speed_max = speed_max;
	}
}

function advanced_part_burst(ps, part_emit, part_) {
	with(part_emit) {
		var part = new particle(part_);
		ds_list_add(ps.particle_list, part);
		return part;
	}
}

function advanced_part_system_destroy(id) {
	with(id) ds_list_destroy(particle_list);
	delete id;
}