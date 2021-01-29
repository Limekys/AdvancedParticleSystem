advanced_part_emitter_burst(ps, part_emiter_, part_type_, 10);

//part_emiter_.point_gravity_x = oPointTarget.x;
//part_emiter_.point_gravity_y = oPointTarget.y;

//move towards mouse
if keyboard_check(vk_control)
advanced_part_emitter_region(part_emiter_, mouse_x-20, mouse_x+20, mouse_y-20, mouse_y+20, room_width-mouse_x, room_height-mouse_y, aps_shape.rectangle, aps_distr.linear);

if keyboard_check(vk_shift)
advanced_part_emitter_region(part_emiter_, x-20, x+20, y-20, y+20, mouse_x, mouse_y, aps_shape.rectangle, aps_distr.linear);

ps.step();