# Advanced Particle System

[WIKI PAGE](https://github.com/Limekys/AdvancedParticleSystem/wiki/Main)

# Compare
Game Maker particle system:
```js
part_sys = part_system_create();

part_emit = part_emitter_create(part_sys);
part_emitter_region(part_sys, part_emit, x-20, x+20, y-20, y+20, ps_shape_rectangle, ps_distr_linear);

part = part_type_create();
part_type_gravity(part, 0.1, 270);
part_type_life(part, 60, 120);
part_type_size(part, 1, 1, 0, 0);
part_type_orientation(part, 0, 0, 0, 0, 0);
part_type_sprite(part, s_pixel, false, false, false);
part_type_speed(part, 0.25, 0.25, 0, 0);
part_type_direction(part, 0, 359, 0, 0);
```

Advanced particle system:
```js
ps = new advanced_part_system();
ps.particle_system_debug_mode = global.particles_debug_mode;
pe = new advanced_part_emitter(ps, x-20, x+20, y-20, y+20, aps_shape.rectangle, aps_distr.linear);

pt1 = new advanced_part_type();
pt1.part_gravity(0.1, 270)
.part_life(60, 120)
.part_size(1, 1, 0, 0)
.part_orientation(0, 0, 0, 0, false)
.part_image(s_pixel, 0, c_white, false, false, false)
.part_speed(0.25, 0.25, 0, 0)
.part_direction(0, 359, 0, 0);
```

# Simple example
All functions looks like standart game maker particle system. We are create particle system, emitter and particle type.

Create event:
```js
ps = new advanced_part_system();
ps.particle_system_debug_mode = global.particles_debug_mode;
pe = new advanced_part_emitter(ps, x-20, x+20, y-20, y+20, aps_shape.rectangle, aps_distr.linear);

pt1 = new advanced_part_type();
pt1
	.part_gravity(0.1, 270)
	.part_life(60, 120)
	.part_size(1, 1, 0, 0)
	.part_orientation(0, 0, 0, 0, false)
	.part_image(s_pixel, 0, c_white, false, false, false)
	.part_speed(0.25, 0.25, 0, 0)
	.part_direction(0, 359, 0, 0)
```

For our particle system to work, we need to add a step function to the step event. And of course to create our particles need to run burst function almost like the standard system, all functions look identical, except that at the beginning ascribed to "advanced_".

Step event:
```js
ps.step();
advanced_part_emitter_burst(ps, pe, pt1, 1);
```

But in order for our particles to be visible, they need to be drawn on the screen, for this you just need to run the draw function in the "draw" event.

Draw event:
```js
ps.draw();
```

Done!

![Simple particle example](https://i.ibb.co/QQD1JPN/v-V1-G786meb-1.gif)

***

# Why advanced?

## Point gravity

Because, as first, we have **part_point_gravity** function!

```js
ps = new advanced_part_system();
ps.particle_system_debug_mode = global.particles_debug_mode;

part_emitter1 = new advanced_part_emitter(ps, x-20, x+20, y, y, aps_shape.rectangle, aps_distr.linear);

part_type1 = new advanced_part_type();
with(part_type1) {
	part_point_gravity(0.15, other.x, other.y);
	part_life(150,200);
	part_size(0.5, 3, 0, 0);
	part_image(s_pixel, 0, c_aqua, false, false, false);
	part_speed(2, 5, 0, 0);
	part_direction(0, 359, 0, 0);
	part_blend(true);
	part_alpha3(0, 1, 0);
	part_step_function(
		function() {
			if sqrt(sqr(mouse_x - x) + sqr(mouse_y - y)) < 16 {
				color = c_blue;
			} else {
				color = c_aqua;
			}
		}
	);
}

part_emitter2 = new advanced_part_emitter(ps, x-12, x+12, y, y, aps_shape.rectangle, aps_distr.linear);
part_type2 = new advanced_part_type();
with(part_type2) {
	part_life(30,60);
	part_size(0.5, 2, 0, 0);
	part_image(s_pixel, 0, c_aqua, false, false, false);
	part_speed(2, 5, 0, 0);
	part_direction(70, 110, 0, 0);
	part_alpha3(1, 1, 0);
}
```

![Point gravity particles](https://i.ibb.co/TtW5DrV/n-XPf-Hhjg-SD.gif)

## Delta time

And, as second, we have delta time! Which give us a huge control with particles speed! At low and high FPS we have the same speed of particles.
To turn on delta time just call **enabledelta()** from advanced_part_system struct.
With delta enabled you should remember to setup right speed, gravity amount and life values! For example without deltatime we should setup life 60 for 1 second life for this particle with room speed 60 and with deltatime we should setup life to 1 for 1 second life regardless room speed. For burst particles with **advanced_part_emitter_burst** function without deltatime 1 for 60 particles each second with room speed 60 and with deltatime 60 to burst 60 particle within a second!

```js
ps = new advanced_part_system();
ps.enabledelta();
```

Example with 15 FPS: left particles is standart GMS2 particle system, middle is advanced particle system without deltatime and right with deltatime.

![Deltatime example](https://i.ibb.co/68Bs97D/z-CI07t-WEi9-1.gif)

## Collisions

For collisions we have _**part_step_function**_. With which we can add what you want including collisions!

For example collisions with objects:

```js
part_step_function(
	function() {
		if position_meeting(x, y, oPointTarget) {
			color = c_red;
			sprite = s_heart;
		}
	}
);
```

And result is:

![Collision with objects](https://i.ibb.co/Cwnc1yD/c9g3ajc-BSe.gif)

Distance to mouse:

```js
part_step_function(
	function() {
		if sqrt(sqr(mouse_x - x) + sqr(mouse_y - y)) < 16 {
			color = c_red;
		} else {
			color = c_aqua;
		}
	}
);
```
![Result](https://i.ibb.co/PzNQCJT/rf4-Ff-DALt8.gif)

Or just a rain:

```js
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
	part_size(0.25, 0.5, 0, 0);
	part_orientation(0, 360, 0, 0, true);
	part_scale(1, 2);
	part_alpha3(0.5, 0.5, 0);
	part_step_function(
		function() {
			if y >= room_height {
				y = room_height;
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
	part_size(0.5, 1, 0, 0);
	part_alpha3(0.5, 0.5, 0.5);
	part_death(5, other.water_drops);
	part_step_function(
		function() {
			if y >= room_height {
				y = room_height - 1;
				life = 0;
			}
		}
	);
}
```
![Rain drops](https://github.com/user-attachments/assets/7d82bd21-85cf-400a-b98c-e9ab50f0cf08)


***

# Fireworks!

Create event:

```js
ps = new advanced_part_system();
ps.particle_system_debug_mode = global.particles_debug_mode;
ps.enabledelta();

em = new advanced_part_emitter(ps, x-4, x+4, y-2, y+2, aps_shape.ellipse, aps_distr.linear);

boom_part = new advanced_part_type();
with(boom_part) {
	//lifetime
	part_life(60 / 60, 120 / 60);
	//looks
	part_image(sFirework, 0, c_white, false, false, true);
	part_size(0.02, 0.05, -0.00025 * 60, 0);
	part_orientation(0, 360, 0, 0, false);
	part_alpha3(0.75, 1, 0);
	part_blend(true);
	//moving
	part_gravity(0.005 * 60 * 60, 270);
	part_speed(0.01 * 60, 0.5 * 60, 0, 0);
	part_direction(0, 360, 0, 0);
}

cinder_part = new advanced_part_type();
with(cinder_part) {
	//lifetime
	part_life(90 / 60, 140 / 60);
	//looks
	part_image(s_pixel, 0, c_white, false, false, true);
	part_size(0.25, 0.5, 0, 0);
	part_orientation(0, 0, 0, 0, false);
	part_color3(c_yellow, c_yellow, c_red);
	part_alpha3(1, 1, 0);
	//moving
	part_gravity(0.005 * 60 * 60, 270);
	part_speed(0.05 * 60, 0.2 * 60, 0, 0);
	part_direction(0, 360, 0, 0);
}

fire_part = new advanced_part_type();
with(fire_part) {
	//lifetime
	part_life(60 / 60, 90 / 60);
	//looks
	part_image(s_pixel, 0, c_white, false, false, false);
	part_size(0.5, 0.5, 0, 0);
	part_orientation(0, 359, 0, 0, false);
	part_alpha3(1, 1, 0);
	//moving
	part_gravity(0.01 * 60 * 60, 270);
	part_speed(1 * 60, 2 * 60, 0, 0);
	part_direction(90-15, 90+15, 0, 0);
	
	part_death(50, other.boom_part);
	part_step(10, other.cinder_part);
}
```

Step event:

```js
ps.step();
advanced_part_emitter_burst(ps, em, fire_part, 1);
```

And how it looks!

![Firework](https://i.ibb.co/H4hzVxh/1zx-QERzp-Tx.gif)

***

# Conclusion

_**We have a very interesting particle system with functions that are not in the standard particle system, but not the most productive! I try to do my best to optimize it. If you like, you can help develop this project!**_
