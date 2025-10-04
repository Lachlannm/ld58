///@desc Moves from toward to by the delta amount. Will not go past to.
///@arg _from real
///@arg _to real
///@arg _delta real
function move_toward(_from, _to, _delta){
	var dir = sign(_to-_from)
	var dist = abs(_to-_from)
	
	if dist < _delta
	{
		return _to	
	}
	return _from + _delta*dir
}

//move_toward(5, 10, 4)    # Returns 9
//move_toward(10, 5, 4)    # Returns 6
//move_toward(5, 10, 9)    # Returns 10
//move_toward(10, 5, -1.5) # Returns 11.5