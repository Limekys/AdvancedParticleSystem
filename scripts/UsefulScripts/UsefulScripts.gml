function Approach(_value, _dest, _amount) {
	///@desc Approach(_value, _dest, _amount)
	return (_value + clamp(_dest-_value, -_amount*global.dt_steady*60, _amount*global.dt_steady*60));
}

function ApproachDelta(_value, _dest, _amount) {
	///@desc ApproachDelta(_value, _dest, _amount)
	return (_value + clamp(_dest-_value, -_amount*global.dt_steady, _amount*global.dt_steady));
}

function Chance(_value) {
	return _value>random(1);
}

function Wave(_from, _dest, _duration, _offset) {
	var a4 = (_dest - _from) * 0.5;
	return _from + a4 + sin((((current_time * 0.001) + _duration * _offset) / _duration) * (pi*2)) * a4;
}

function ReachTween(_value, _destination, _smoothness) {
	return(lerp(_value, _destination, 1/_smoothness*global.dt_steady*60)); // 1/_smoothness*global.dt_steady*60 //1 - power(1 / _smoothness, global.dt_steady)
}

function DrawSetText(_color, _font, _haling, _valing, _alpha) {
	/// @desc DrawSetText(colour,font,halign,valign,alpha)
	draw_set_colour(_color);
	draw_set_font(_font);
	draw_set_halign(_haling);
	draw_set_valign(_valing);
	draw_set_alpha(_alpha);
}

function DrawTextShadow(_x, _y, _string) {
	var _colour = draw_get_colour();
	draw_set_colour(c_black);
	draw_text(_x+1, _y+1, _string);
	draw_set_colour(_colour);
	draw_text(_x, _y, _string);
}

function draw_text_outline(_x, _y, _string, _outwidth, _outcolor, _outfidelity) {
	///@desc draw_text_outline(x,y,str,outwidth,outcol,outfidelity)
	//Created by Andrew McCluskey http://nalgames.com/
	
	var dto_dcol=draw_get_color();

	draw_set_color(_outcolor);

	for(var dto_i=45; dto_i<405; dto_i+=360/_outfidelity)
	{
	    draw_text(_x+lengthdir_x(_outwidth,dto_i),_y+lengthdir_y(_outwidth,dto_i),_string);
	}

	draw_set_color(dto_dcol);
	draw_text(_x,_y,_string);
}

function draw_text_outline_transformed(_x, _y, _string, _xscale, _yscale, _outwidth, _outcolor, _outfidelity) {
	/// @description draw_text_outline_transformed(x,y,str,outwidth,outcol,outfidelity)
	var dto_dcol=draw_get_color();
	
	draw_set_color(_outcolor);

	for(var dto_i=45; dto_i<405; dto_i+=360/_outfidelity)
	{
	    draw_text_transformed(_x+lengthdir_x(_outwidth,dto_i),_y+lengthdir_y(_outwidth,dto_i),_string,_xscale,_yscale,0);
	}

	draw_set_color(dto_dcol);
	draw_text_transformed(_x,_y,_string,_xscale,_yscale,0);
}

function draw_rectangle_width(x1, y1, x2, y2, _width, _inside, _outline) {
	///@desc draw_rectangle_width(x1,y1,x2,y2,width,inside,outilne)
	
	if _inside == false
	for (var i = 0; i < _width; ++i) {
	    draw_rectangle(x1-i,y1-i,x2+i,y2+i,_outline);
	}
	else
	for (var i = 0; i < _width; ++i) {
	    draw_rectangle(x1+i,y1+i,x2-i,y2-i,_outline);
	}
}

function string_zeroes_scripts(_string, _nubmer) {
	/// @description string_zeroes_scripts(string,nubmer)
	//Returns _string as a string with zeroes if it has fewer than _nubmer characters
	///eg string_zeroes(150,6) returns "000150" or
	///string_zeroes(mins,2)+":"+string_zeroes(secs,2) might return "21:02"
	///Created by Andrew McCluskey, use it freely

	var rtn = "";
	if string_length(string(_string))<_nubmer {
	    repeat(_nubmer-string_length(string(_string))) rtn += "0"
	}
	rtn += string(_string)
	return rtn;
}

function draw_circle_curve(_xx, _yy, _radius, _bones, _angle, _angleadd, _width, _outline) {
	///@desc draw_circle_curve(x,y,r,bones,ang,angadd,width,outline)

	_bones = max(3,_bones);
	
	var a,lp,lm,dp,dm,AAa,Wh;
	a = _angleadd/_bones;
	Wh = _width/2;
	lp = _radius+Wh;
	lm = _radius-Wh;
	AAa = _angle+_angleadd;
	
	if _outline {
		//OUTLINE
		draw_primitive_begin(pr_trianglestrip);; //Change to pr_linestrip, to see how it works.
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

function draw_healthbar_circular(center_x, center_y, _radius, _start_ang, _health, _sprite) {
	///@desc draw_healthbar_circular(center_x,center_y,radius,start_angle,percent_health,sprite)
	
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
