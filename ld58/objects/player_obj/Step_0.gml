var gas_pressed = keyboard_check(ord("W")) or keyboard_check(ord("Z"))
var brake_pressed = keyboard_check(ord("S"))
var turning_left = keyboard_check(ord("A")) or keyboard_check(ord("Q"))
var turning_right = keyboard_check(ord("D"))

// Get current direction vector
// Negative since physics rotations are opposite normal rotations
direction_x = lengthdir_x(1, -phy_rotation)
direction_y = lengthdir_y(1, -phy_rotation)

var speed_in_meters_per_second = pixels_to_meters(point_distance(0,0,phy_linear_velocity_x, phy_linear_velocity_y))

var new_relative_direction = dot_product(direction_x, direction_y, phy_linear_velocity_x, phy_linear_velocity_y)

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
audio_emitter_pitch(emitter,1+gas_amount*0.5)

var applied_brake_strength = 0
if brake_pressed
{
    brake_amount = clamp(brake_amount+brake_rate,0,1)
    
    if current_relative_direction > 0
    {
        if new_relative_direction <= 0
        {
            // Was breaking and have now come to a stop
            applied_brake_strength = 0
            phy_linear_velocity_x = 0
            phy_linear_velocity_y = 0
            
            audio_play_sound(brake_sfx,0,false)
        }
        else
        {
            // Regular breaking
        	applied_brake_strength = brake_strength
        }
        brake_reverse_timeout = false
        alarm[2] = -1
    }
    
    if current_relative_direction <= 0 and (is_reversing or not was_brake_pressed or brake_reverse_timeout)
    {
        // Reversing
        applied_brake_strength = gas_strength * reverse_fraction
        is_reversing = true
        
        brake_reverse_timeout = false
        alarm[2] = -1
    }
    else
    {
        if current_relative_direction <= 0 and alarm[2] == -1
        {
            // Timeout after 2 second holding the reverse
            alarm[2] = game_get_speed(gamespeed_fps) * 2
        }
        is_reversing = false
    }
    
}
else
{
    is_reversing = false
	brake_amount = clamp(brake_amount-brake_rate,0,1)
    
    brake_reverse_timeout = false
    alarm[2] = -1
}
was_brake_pressed = brake_pressed


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

var speed_fraction = speed_in_meters_per_second / max_speed_meters_per_second
var speed_turn_multiplier = (1-speed_fraction) * 1 + speed_fraction * max_speed_turn_multiplier
rotation *= speed_turn_multiplier

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

var applied_gas_strength = gas_strength

if current_relative_direction >= 0
{
    // Account for max speed
    
    var speed_change_threshold = max_speed_dropoff_threshold * max_speed_meters_per_second
    
    if speed_in_meters_per_second > speed_change_threshold
    {
        // Progression is 0 at the threshold, 1 at max speed
        var progression = (speed_in_meters_per_second - speed_change_threshold) / (max_speed_meters_per_second - speed_change_threshold)
        // Lerp between normal gas_strength and max_speed_force
        applied_gas_strength = (1-progression) * gas_strength + progression * max_speed_force
    }
}
else
{
    // Treat accelerating from reverse the same as braking
    
	applied_gas_strength = brake_strength
    
    if gas_pressed and new_relative_direction >= 0
    {
        audio_play_sound(brake_sfx,0,false)
    }
}

force_total = (gas_amount*applied_gas_strength - brake_amount*applied_brake_strength)

physics_apply_local_force(0, 0, force_total, 0)

current_relative_direction = new_relative_direction

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
    var current_gain = audio_emitter_get_gain(drift_emitter)
    
    audio_emitter_gain(drift_emitter, move_toward(current_gain, 1, 0.03))
    
    part_type_direction(drift_part, -phy_rotation, -phy_rotation, 0, 0)
    part_particles_create(drift_particle_sys, x, y, drift_part, 1)
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