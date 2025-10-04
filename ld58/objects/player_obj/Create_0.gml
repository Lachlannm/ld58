gas_rate = 0.015
gas_amount = 0
gas_strength = 0.01

brake_rate = 0.02
brake_amount = 0
brake_strength = 0.008

move_speed = 0
max_speed = 3

turn_speed = 0.1
turn_amount = 0
turn_rate = 0.02
max_turn_amount = 35

move_drag = gas_strength/max_speed
drag = 0.005

drift_amount = 0
drift_rate = 0.2
is_drifting = false
centripital = 0

garbage_stored = 0
max_garbage = 10

function increment_garbage(_value)
{
	if garbage_stored+_value < max_garbage
	{
		garbage_stored += _value
		return true
	}
	return false
}

// create the camera that follows the player
instance_create_layer(0,0,layer,camera_obj)