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
move_speed = phy_speed

if turning_left
{
	turn_amount = clamp(turn_amount+turn_rate,-1,1)
}
else if turning_right
{
	turn_amount = clamp(turn_amount-turn_rate,-1,1)
}
else
{
	turn_amount = move_toward(turn_amount, 0, turn_rate)
}

rotation = (turn_amount*max_turn_amount*phy_speed)/42
phy_rotation -= rotation

if keyboard_check_pressed(vk_space)
{
	collect_garbage()	
}

//image_angle = phy_rotation

var speed_dir = phy_rotation+drift_amount

move_force_current = (gas_amount*gas_strength - brake_amount*brake_strength)*5000
var force_x = lengthdir_x(move_force_current,phy_rotation)
var force_y = lengthdir_y(move_force_current,phy_rotation)

physics_apply_force(x, y, force_x, -force_y)

//x += lengthdir_x(move_speed,speed_dir)
//y += lengthdir_y(move_speed,speed_dir)

collector.x = x
collector.y = y
collector.image_angle = image_angle