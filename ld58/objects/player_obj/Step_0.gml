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
	if !brake_held
	{
		audio_play_sound(brake_sfx,0,false)
	}
	brake_held = true
}
else
{
	brake_amount = clamp(brake_amount-brake_rate,0,1)
	brake_held = false
}
audio_emitter_pitch(emitter,1+gas_amount*0.5)


if turning_left
{
	turn_amount += turn_rate
}
else if turning_right
{
	turn_amount -= turn_rate
}
else
{
    turn_amount = move_toward(turn_amount, 0, turn_rate)
}
turn_amount = clamp(turn_amount,-1,1)

var rotation = (turn_amount*max_turn_amount*phy_speed)/42


phy_rotation -= rotation

rotation_looped = -phy_rotation % 360
if rotation_looped < 0
{
    rotation_looped += 360
}

image_angle = rotation_looped

force_total = (gas_amount*gas_strength - brake_amount*brake_strength) * 5000

physics_apply_local_force(0, 0, force_total, 0)



//physics_apply_force(x, y, 50, 0)


if keyboard_check_pressed(vk_space)
{
	collect_garbage()
}
collector.x = x
collector.y = y
collector.image_angle = image_angle