var gas_pressed = keyboard_check(ord("W"))
var brake_pressed = keyboard_check(ord("S"))
var turning_left = keyboard_check(ord("A"))
var turning_right = keyboard_check(ord("D"))

// Get current direction vector
// Negative since physics rotations are opposite normal rotations
direction_x = lengthdir_x(1, -phy_rotation)
direction_y = lengthdir_y(1, -phy_rotation)

if gas_pressed
{
	gas_amount = clamp(gas_amount+gas_rate,0,1)	
    if is_drifting
    {
        drift_strength = clamp(drift_strength+drift_rate, 0, 1)
    }
    else
    {
    	drift_strength = 0
    }
}
else
{
	gas_amount = clamp(gas_amount-gas_rate,0,1)
    drift_strength = 0
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

if gas_pressed and is_drifting
{
    gas_amount *= drift_gas_constant_multiplier + drift_strength*drift_gas_multiply_by_strength
}


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

if is_drifting
{
    rotation *= drift_max_turn_amount_multiplier
}

if dot_product(phy_linear_velocity_x, phy_linear_velocity_y, direction_x, direction_y) < 0
{
    // Reversing, so turning is reversed
    rotation *= -1
}
phy_rotation -= rotation

rotation_looped = -phy_rotation % 360
if rotation_looped < 0
{
    rotation_looped += 360
}

image_angle = rotation_looped

force_total = (gas_amount*gas_strength - brake_amount*brake_strength) * 5000

physics_apply_local_force(0, 0, force_total, 0)


// Get the horizontal movement

if phy_speed > 0
{
    // Then, project the current velocity onto that
    var projected_velocity = project_vector(phy_linear_velocity_x, phy_linear_velocity_y, direction_x, direction_y)
    
    
    // Then subtract the original velocity to get the required change
    needed_velocity_x = projected_velocity[0] - phy_linear_velocity_x
    needed_velocity_y = projected_velocity[1] - phy_linear_velocity_y
    
    var total_needed_velocity = point_distance(0,0,needed_velocity_x,needed_velocity_y)
    
    if total_needed_velocity > tire_max_correction_force
    {
        is_drifting = true
        
        // Normalize then scale to max
        needed_velocity_x = needed_velocity_x / total_needed_velocity * tire_correction_force_drifting
        needed_velocity_y = needed_velocity_y / total_needed_velocity * tire_correction_force_drifting
    }
    else if total_needed_velocity < tire_min_correction_force_exit_drift
    {
        if is_drifting and gas_pressed
        {
            physics_apply_local_impulse(0, 0, drift_strength * drift_exit_impulse, 0)
        }
        
    	is_drifting = false
    }
    
    physics_apply_force(x, y, needed_velocity_x*60, needed_velocity_y*60)
}

if is_drifting
{
    part_type_direction(drift_part, -phy_rotation, -phy_rotation, 0, 0)
    part_particles_create(drift_particle_sys, x, y, drift_part, 1)
    
    var current_gain = audio_emitter_get_gain(drift_emitter)
    
    audio_emitter_gain(drift_emitter, move_toward(current_gain, 1, 0.03))
}
else
{
    audio_emitter_gain(drift_emitter, 0)
    
    var current_gain = audio_emitter_get_gain(drift_emitter)
    
    audio_emitter_gain(drift_emitter, move_toward(current_gain, 0, 0.03))
}

physics_apply_torque(clamp(-phy_angular_velocity*60, -50, 50))



if keyboard_check_pressed(vk_space)
{
	collect_garbage()
}
collector.x = x
collector.y = y
collector.image_angle = image_angle