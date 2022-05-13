function Wave(_from, _dest, _duration, _offset) {
	var a4 = (_dest - _from) * 0.5;
	return _from + a4 + sin((((current_time * 0.001) + _duration * _offset) / _duration) * (pi*2)) * a4;
}
