//Useful functions by Limekys (This script has MIT Licence)
#macro LIMEKYS_USEFUL_FUNCTIONS_VERSION "2023.03.11"

#macro DT global.dt_steady

function Approach(_value, _dest, _amount) {
	return (_value + clamp(_dest-_value, -_amount, _amount));
}

function ApproachDelta(_value, _dest, _amount) {
	return (_value + clamp(_dest-_value, -_amount*DT, _amount*DT));
}

///@arg {Real} value
///@arg {Real} destination
///@arg {Real} smoothness
///@arg {Real} threshold
///@returns {Real}
function SmoothApproach(value, destination, smoothness, threshold = 0.01) {
	var _difference = destination - value;
    if (abs(_difference) < threshold) return destination;
	return lerp(value, destination, 1/smoothness);
}

///@arg {Real} value
///@arg {Real} destination
///@arg {Real} smoothness
///@arg {Real} threshold
///@returns {Real}
function SmoothApproachDelta(value, destination, smoothness, threshold = 0.01) {
	var _difference = destination - value;
    if (abs(_difference) < threshold) return destination;
	return lerp(value, destination, 1/smoothness*DT*60); // 1/_smoothness*DT*60 // 1 - power(1 / _smoothness, DT)
}

///@func Chance(value)
function Chance(value) {
	return value > random(1);
}

///@func Wave(value1, value2, duration, offset)
///@desc Returns a value that will wave back and forth between [from-to] over [duration] seconds based on current time
/// Examples:
/// image_angle = Wave(-45,45,1,0)  -> rock back and forth 90 degrees in a second
/// x = Wave(-10,10,0.25,0)         -> move left and right quickly
/// Or here is a fun one! Make an object be all squishy!! ^u^
/// image_xscale = Wave(0.5, 2.0, 1.0, 0.0)
/// image_yscale = Wave(2.0, 0.5, 1.0, 0.0)
function Wave(value1, value2, duration, offset) {
	var _a = (value2 - value1) * 0.5;
	return value1 + _a + sin((((current_time * 0.001) + duration * offset) / duration) * (pi*2)) * _a;
}

function DrawSetText(_color = undefined, _font = undefined, _haling = undefined, _valing = undefined, _alpha = undefined) {
	if _color != undefined draw_set_colour(_color);
	if _font != undefined draw_set_font(_font);
	if _haling != undefined draw_set_halign(_haling);
	if _valing != undefined draw_set_valign(_valing);
	if _alpha != undefined draw_set_alpha(_alpha);
}

///@desc DrawTextOutline(x,y,str,outwidth,outcol,outfidelity)
///Created by Andrew McCluskey http://nalgames.com/
///x,y: Coordinates to draw
///str: String to draw
///outwidth: Width of outline in pixels
///outcol: Colour of outline (main text draws with regular set colour)
///outfidelity: Fidelity of outline (recommended: 4 for small, 8 for medium, 16 for larger. Watch your performance!)
function DrawTextOutline(_x, _y, _string, _outwidth, _outcolor, _outfidelity) {
	var _dto_dcol = draw_get_color();
	draw_set_color(_outcolor);
	for(var dto_i = 45; dto_i < 405; dto_i += 360/_outfidelity) {
	    draw_text(_x + lengthdir_x(_outwidth, dto_i), _y + lengthdir_y(_outwidth, dto_i), _string);
	}
	draw_set_color(_dto_dcol);
	draw_text(_x,_y,_string);
}

/// @description DrawTextOutlineTransformed(x,y,str,outwidth,outcol,outfidelity)
///Created by Andrew McCluskey http://nalgames.com/
///Edited version by Limekys
///x,y: Coordinates to draw
///str: String to draw
///outwidth: Width of outline in pixels
///outcol: Colour of outline (main text draws with regular set colour)
///outfidelity: Fidelity of outline (recommended: 4 for small, 8 for medium, 16 for larger. Watch your performance!)
function DrawTextOutlineTransformed(_x, _y, _string, _xscale, _yscale, _outwidth, _outcolor, _outfidelity) {
	var _dto_dcol = draw_get_color();
	draw_set_color(_outcolor);
	for(var dto_i = 45; dto_i < 405; dto_i += 360/_outfidelity) {
	    draw_text_transformed(_x + lengthdir_x(_outwidth, dto_i), _y + lengthdir_y(_outwidth, dto_i), _string, _xscale, _yscale, 0);
	}
	draw_set_color(_dto_dcol);
	draw_text_transformed(_x,_y,_string,_xscale,_yscale,0);
}

function DrawTextShadow(_x, _y, _string) {
	var _colour = draw_get_colour();
	draw_set_colour(c_black);
	draw_text(_x+1, _y+1, _string);
	draw_set_colour(_colour);
	draw_text(_x, _y, _string);
}

///@desc example: DrawTextSoftShadow(10,10,"Hello World!", font_name, c_white, c_black, 0,5,6,0.01, );
function DrawTextSoftShadow(_x, _y, _string, _font, _offset_x, _offset_y, _blurfactor, _shadow_colour, _shadow_strenght, _text_colour) {
	draw_set_font(_font);
	var _shadow_strenght_calc = _shadow_strenght/(_blurfactor * _blurfactor)
	draw_set_alpha(_shadow_strenght_calc);
	draw_set_colour(_shadow_colour);
	
	var _bx = _blurfactor/2;
	var _by = _blurfactor/2;

	for (var ix = 0; ix < _blurfactor; ix++) {
	    for (var iy = 0; iy < _blurfactor; iy++) {
	        draw_text((_x-_bx) +_offset_x + ix, (_y-_by) +_offset_y + iy, _string);
	    }
	}
	draw_set_alpha(1);
	draw_set_colour(_text_colour);
	draw_text(_x, _y, _string);
}

function DrawRectangleWidth(x1, y1, x2, y2, _width, _inside, _outline) {
	if _inside == false
	for (var i = 0; i < _width; ++i) {
	    draw_rectangle(x1-i,y1-i,x2+i,y2+i,_outline);
	}
	else
	for (var i = 0; i < _width; ++i) {
	    draw_rectangle(x1+i,y1+i,x2-i,y2-i,_outline);
	}
}

///@desc StringZeroes(string,nubmer)
///Returns _string as a string with zeroes if it has fewer than _nubmer characters
///eg StringZeroes(150,6) returns "000150" or
///StringZeroes(mins,2)+":"+StringZeroes(secs,2) might return "21:02"
///Created by Andrew McCluskey, use it freely
function StringZeroes(_string, _nubmer) {
	var _str = "";
	if string_length(string(_string)) < _nubmer {
	    repeat(_nubmer-string_length(string(_string))) _str += "0";
	}
	_str += string(_string);
	return _str;
}

///@desc DrawCircleCurve(x,y,r,bones,ang,angadd,width,outline)
///x,y — Center of circle.
///r — Radius.
///bones — Amount of bones. More bones = more quality, but less speed. Minimum — 3.
///ang — Angle of first circle's point.
///angadd — Angle of last circle's point (relative to ang). 
///width — Width of circle (may be positive or negative).
///outline — 0 = curve, 1 = sector. 
function DrawCircleCurve(_xx, _yy, _radius, _bones, _angle, _angleadd, _width, _outline) {
	_bones = max(3,_bones);
	
	var a,lp,lm,dp,dm,AAa,Wh;
	a = _angleadd/_bones;
	Wh = _width/2;
	lp = _radius+Wh;
	lm = _radius-Wh;
	AAa = _angle+_angleadd;
	
	if _outline {
		//OUTLINE
		draw_primitive_begin(pr_trianglestrip); //Change to pr_linestrip, to see how it works.
		draw_vertex(_xx+lengthdir_x(lm,_angle),_yy+lengthdir_y(lm,_angle)); //First point.
		for(var i=1; i<=_bones; ++i)
		{
			dp = _angle+a*i;
			dm = dp-a;
			draw_vertex(_xx+lengthdir_x(lp,dm),_yy+lengthdir_y(lp,dm));
			draw_vertex(_xx+lengthdir_x(lm,dp),_yy+lengthdir_y(lm,dp));
		}
		draw_vertex(_xx+lengthdir_x(lp,AAa),_yy+lengthdir_y(lp,AAa));
		draw_vertex(_xx+lengthdir_x(lm,AAa),_yy+lengthdir_y(lm,AAa)); //Last two points to make circle look right.
		//OUTLINE
	} else {
		//SECTOR
		draw_primitive_begin(pr_trianglefan); //Change to pr_linestrip, to see how it works.
		draw_vertex(_xx,_yy); //First point in the circle's center.
		for(var i=1; i<=_bones; ++i)
		{
			dp = _angle+a*i;
			dm = dp-a;
			draw_vertex(_xx+lengthdir_x(lp,dm),_yy+lengthdir_y(lp,dm));
		}
		draw_vertex(_xx+lengthdir_x(lp,AAa),_yy+lengthdir_y(lp,AAa)); //Last point.
		//SECTOR
	}
	draw_primitive_end();
}

function DrawHealthbarCircular(center_x, center_y, _radius, _start_ang, _health, _sprite) {
	var tex,steps,thick,oc;
	tex = sprite_get_texture(_sprite,0);
	steps = 200;
	thick = sprite_get_height(_sprite);

	if ceil(steps*(_health/100)) >= 1 {
		
		oc = draw_get_color();
		draw_set_color(c_white);
		
	    var step,ang,side,hps,hpd;
	    step = 0;
	    ang = _start_ang;
	    side = 0;
	    draw_primitive_begin_texture(pr_trianglestrip,tex);
	    draw_vertex_texture(center_x+lengthdir_x(_radius-thick/2+thick*side,ang),center_y+lengthdir_y(_radius-thick/2+thick*side,ang),side,side);
	    side = !side;
	    draw_vertex_texture(center_x+lengthdir_x(_radius-thick/2+thick*side,ang),center_y+lengthdir_y(_radius-thick/2+thick*side,ang),side,side);
	    side = !side;
	    draw_vertex_texture(center_x+lengthdir_x(_radius-thick/2+thick*side,ang+360/steps),center_y+lengthdir_y(_radius-thick/2+thick*side,ang+360/steps),side,side);
	    side = !side;
	    hps = _health/(ceil(steps*(_health/100))+1);
	    hpd = 0;
	    repeat ceil(steps*(_health/100)+1) {
	        step++;
	        if step == ceil(steps*(_health/100)+1) { //final step
	            ang += (360/steps)*(_health - hpd)/2;
	            if ang>_start_ang+360 ang=_start_ang+360
	            draw_vertex_texture(center_x+lengthdir_x(_radius-thick/2+thick*side,ang),center_y+lengthdir_y(_radius-thick/2+thick*side,ang),side,side);
	            side = !side;
	            draw_vertex_texture(center_x+lengthdir_x(_radius-thick/2+thick*side,ang),center_y+lengthdir_y(_radius-thick/2+thick*side,ang),side,side);
	        }
	        else {
	            ang+=360/steps;
	            draw_vertex_texture(center_x+lengthdir_x(_radius-thick/2+thick*side,ang),center_y+lengthdir_y(_radius-thick/2+thick*side,ang),side,side);
	            side = !side;
	        }
	        hpd += hps;
	    }
	    draw_primitive_end();
	    draw_set_color(oc);
	}
}

function print_format(_string, struct) {
	var list = variable_struct_get_names(struct);
	for(var i = 0; i < array_length(list); i++){
		var find = "${"+list[i]+"}"
		_string = string_replace_all(_string, find, struct[$ list[i]]);
	}
	return _string;
}

function print() {
	var time = print_format("[${hour}:${minute}:${second}]",{
		hour: current_hour,
		minute: current_minute,
		second: current_second
	});
	var caller = print_format("[${caller}]",{caller: argument[0]});
	var msg = "";
	for(var i = 1; i < argument_count; i++){
		msg += string(argument[i]) + " ";
	}
	var result = time+caller+": "+msg;
	show_debug_message(result);
	//ds_list_insert(global.console_output, 0, result);
	//var file = file_text_open_append(global.LOG_FILE);
	//file_text_write_string(file,result);
	//file_text_writeln(file);
	//file_text_close(file);
}

///@desc Saves a successively numbered screenshot within the working directory
///Returns true on success, false otherwise.
///name prefix to assign screenshots, string
///folder subfolder to save to (eg. "screens\"), string
function SaveScreenshot(name) {
	var i = 0, fname;
	
	if !directory_exists(working_directory + "Screenshots") directory_create(working_directory+"Screenshots");
	// If there is a file with the current name and number,
	// advance counter and keep looking:
	do {
	    fname = working_directory+"\\" + "Screenshots\\" + name + "_" + string(i) + ".png";
	    i++;
	} until (!file_exists(fname));
	// Once we've got a unused number we'll save the screenshot under it:
	screen_save(fname);
	return file_exists(fname);
}

///@desc Returns the background data captured on the screen which can then be drawn later on.
function MakeScreenshot() {
	var ret = -1;
	var sfc_width = surface_get_width(application_surface);
	var sfc_height = surface_get_height(application_surface);

	// Create drawing surface
	var sfc = surface_create(sfc_width,sfc_height);
	surface_set_target(sfc);
	// Clear screen;
	// Both draw_clear and draw_rectangle will clear your screen BUT
	// on some systems, it creates ghostly images, for example, when
	// sprites are animated. To prevent those images, both are used.
	var _gpu_cwe = gpu_get_colorwriteenable();
	gpu_set_colorwriteenable(true, true, true, true);
	draw_clear_alpha(c_white, 0);
	draw_rectangle_colour(0,0,sfc_width,sfc_height,c_black,c_black,c_black,c_black,false);
	gpu_set_colorwriteenable(true, true, true, false);
	// Capture screen
	draw_surface(application_surface,0,0);
	ret = sprite_create_from_surface(sfc, 0, 0, sfc_width, sfc_height, false, false, 0, 0);
	// Finalise drawing process and clear surface from memory
	surface_reset_target();
	gpu_set_colorwriteenable(_gpu_cwe[0], _gpu_cwe[1], _gpu_cwe[2], _gpu_cwe[3]);
	surface_free(sfc);

	return ret;
}

function DrawSpriteOffset(sprite, subimg, pos_x, pos_y, xscale = 1, yscale = 1, rotation = 0, color = c_white, alpha = 1, x_offset = 0, y_offset = 0) {
	//Calculate rotation
	var _c = dcos(rotation);
	var _s = dsin(rotation);
	var _rot_x = _c * x_offset + _s * y_offset;
	var _rot_y = _c * y_offset - _s * x_offset;
	//Draw
	draw_sprite_ext(sprite, subimg, pos_x - _rot_x, pos_y - _rot_y, xscale, yscale, rotation, color, alpha);
}

function DrawTextSpriteShadow(pos_x, pos_y, text, sprite_shadow) {
	var _txt_w = string_width(text) + 70;
	//var _txt_h = string_height(_text);
	
	draw_sprite_stretched_ext(sprite_shadow, 0, pos_x - _txt_w/2, pos_y - 44, _txt_w, 88, c_white, 0.5);
	draw_text(pos_x, pos_y, text);
}

///@desc Returns new range from old range
function Range(value, old_min, old_max, new_min, new_max) {
	return ((value - old_min) / (old_max - old_min)) * (new_max - new_min) + new_min;
}

///@arg {String} name
///@arg {Real} seconds
///@arg {Function} _function
///@arg {Real} start_from
function IntervalUpdateFunction(name, seconds, _function, start_from = -1) {
	var n1 = name + "_interval";
	var n2 = name + "_interval_lenght";
	if !variable_instance_exists(self, n1) self[$ n1] = 0;
	if !variable_instance_exists(self, n2) self[$ n2] = start_from == -1 ? seconds : start_from;
	
	self[$ n1] += DT;
	if self[$ n1] >= self[$ n2] {
		self[$ n1] -= self[$ n2];
		_function();
	}
}

///@arg {Array} _array
function ArrayShuffle(_array) {
	var _size = array_length(_array), i, j, k;
	for (i = 0; i < _size; i++)
	{
	    j = irandom_range(i, _size - 1);
	    if (i != j)
	    {
	        k = _array[i];
	        _array[i] = _array[j];
	        _array[j] = k;
	    }
	}
}