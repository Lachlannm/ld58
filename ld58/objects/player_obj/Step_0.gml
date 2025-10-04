var gas_pressed = keyboard_check(ord("W"))
var brake_pressed = keyboard_check(ord("S"))

if gas_pressed
{
	gas_amount = clamp(gas_amount+gas_rate,0,1)	
}
else
{
	gas_amount = clamp(gas_amount-gas_rate,0,1)
}

if brake_pressed
{
	brake_amount = clamp(brake_amount+brake_rate,0,1)	
}
else
{
	brake_amount = clamp(brake_amount-brake_rate,0,1)
}

move_speed = clamp(move_speed + gas_amount*gas_strength - brake_amount*brake_strength - move_drag*move_speed*gas_pressed - drag*!gas_pressed,0,max_speed)
if keyboard_check(ord("A"))
{
	turn_amount = clamp(turn_amount+turn_rate,-1,1)
	move_speed *= 0.999
}
else
{
	if turn_amount > 0
	{
		turn_amount = max(turn_amount-turn_rate,0)	
	}
}

if keyboard_check(ord("D"))
{
	turn_amount = clamp(turn_amount-turn_rate,-1,1)
	move_speed *= 0.999
}
else
{
	if turn_amount < 0
	{
		turn_amount = min(turn_amount+turn_rate,0)	
	}	
}

var rotation = (turn_amount*max_turn_amount*move_speed)/270

if move_speed > 7 and abs(turn_amount*max_turn_amount)/move_speed > 4
{
	drift_amount = clamp(drift_amount-rotation*0.5,-80,80)
	is_drifting = true
}
else
{
	var max_rotation = (max_turn_amount*move_speed)/270
	drift_amount = move_toward(drift_amount,0,max_rotation-abs(rotation))
	is_drifting = false
}

direction += rotation
image_angle = direction

var speed_dir = direction+drift_amount

x += lengthdir_x(move_speed,speed_dir)
y += lengthdir_y(move_speed,speed_dir)

