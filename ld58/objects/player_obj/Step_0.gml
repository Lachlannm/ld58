var gas_pressed = keyboard_check(ord("W"))
var brake_pressed = keyboard_check(ord("S"))
var turning_left = keyboard_check(ord("A"))
var turning_right = keyboard_check(ord("D"))

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

//nathaniel edit
//move_speed = clamp(move_speed + gas_amount*gas_strength - brake_amount*brake_strength - move_drag*move_speed*gas_pressed - drag*!gas_pressed,0,max_speed)
var moving_drag_term = move_drag*move_speed*gas_pressed
var drag_term = drag*!gas_pressed
if move_speed < 0
{
	moving_drag_term *= -1
	drag_term *= -1
}
move_speed = clamp(move_speed + gas_amount*gas_strength - brake_amount*brake_strength - moving_drag_term - drag_term,max_reverse_speed,max_speed)
if abs(move_speed) < 0.01 && !gas_pressed && !brake_pressed {move_speed = 0}
//end

if turning_left
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

if turning_right
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

var rotation = (turn_amount*max_turn_amount*move_speed)/42
centripital = move_speed*sin(rotation)

if !is_drifting
{
	if abs(centripital) > drift_start_threshold and move_speed > drift_start_speed
	{
		is_drifting = true
	}
}
else if not ((turning_left or turning_right) and abs(turn_amount) > 0.2) or move_speed < drift_stop_speed
{
	if abs(centripital) < drift_stop_threshold or move_speed < drift_stop_speed
	{
		is_drifting = false
		
		move_speed = max(move_speed, 2.7)
	}
}

if is_drifting
{
	drift_amount = clamp(drift_amount-rotation*0.5,-80,80)
	//  Slow down when drifting
	var drift_percent = abs(drift_amount/80)
	var slow_down = drift_percent * 0.001
	var multiplier = 1 - slow_down
	move_speed *= multiplier
}
else
{
	var drift_stop_amount = (1-turn_amount)*3
	drift_amount = move_toward(drift_amount,0,drift_stop_amount)
}

if keyboard_check_pressed(vk_space)
{
	collect_garbage()	
}

direction += rotation
image_angle = direction

var speed_dir = direction+drift_amount

x += lengthdir_x(move_speed,speed_dir)
y += lengthdir_y(move_speed,speed_dir)

collector.x = x
collector.y = y
collector.image_angle = image_angle