physics_mass_properties(phy_mass, 0, 0, phy_inertia)

show_debug_message("Mass: {0}", phy_mass)

test_project_vector()

pixels_per_meter = 10
frames_per_second = 60

max_speed_meters_per_second = 0 // Overridden by upgrade
max_speed_dropoff_threshold = 0.7
max_speed_force = 0 // Overridden by upgrade

gas_rate = 0.015
cmd_setter("gas_rate", function(val) { gas_rate = val }, function() { return gas_rate })
gas_amount = 0
cmd_setter("gas_amount", function(val) { gas_amount = val }, function() { return gas_amount })
gas_strength = 0 // Overridden by upgrade
cmd_setter("gas_strength", function(val) { gas_strength = val }, function() { return gas_strength })

brake_rate = 0.02
brake_amount = 0
brake_strength = 0 // Overridden by upgrade

// The fraction of gas_strength for reversing
reverse_fraction = 0.4
was_brake_pressed = false
is_reversing = false
current_relative_direction = 0

// If you brake, and continue to hold the brake, it will eventually timeout
brake_reverse_timeout = false

force_total = 0

move_speed = 0

//nathaniel edit
max_reverse_speed = -0.5
can_crash_again = true
//end edit

turn_amount = 0
turn_rate = 0.02
max_turn_amount = 0 // Overridden by upgrade
cmd_setter("max_turn_amount", function(val) { max_turn_amount = val }, function() { return max_turn_amount })

max_speed_turn_multiplier = 0.7

rotation_looped = 0

cmd_setter("linear_damping", function(val) { phy_linear_damping = val }, function() { return phy_linear_damping })

// Max force the tires apply before start slipping to enter drift
tire_max_correction_force = 12
cmd_setter("tire_max_correction_force", function(val) { tire_max_correction_force = val }, function() { return tire_max_correction_force })
// The tire correction force applied while drifting
// Much lower so it feels like you're slipping
tire_correction_force_drifting = 6
cmd_setter("tire_correction_force_drifting", function(val) { tire_correction_force_drifting = val }, function() { return tire_correction_force_drifting })
// The minimum calculated force you can reach before exiting drift
tire_min_correction_force_exit_drift = 7
cmd_setter("tire_min_correction_force_exit_drift", function(val) { tire_min_correction_force_exit_drift = val }, function() { return tire_min_correction_force_exit_drift })

drift_max_turn_amount_multiplier = 0.8
cmd_setter("drift_max_turn_amount_multiplier", function(val) { drift_max_turn_amount_multiplier = val }, function() { return drift_max_turn_amount_multiplier })

// The rate at which the drift strength increases while drifting (per frame)
drift_rate = 0.01
cmd_setter("drift_rate", function(val) { drift_rate = val }, function() { return drift_rate })
// These are used to tell how the drift affects the gas power
drift_gas_constant_multiplier = 0.5
cmd_setter("drift_gas_constant_multiplier", function(val) { drift_gas_constant_multiplier = val }, function() { return drift_gas_constant_multiplier })
drift_gas_multiply_by_strength = 4
cmd_setter("drift_gas_multiply_by_strength", function(val) { drift_gas_multiply_by_strength = val }, function() { return drift_gas_multiply_by_strength })

// This is the boost that is received when exiting,
//  multiplied by current drift_strength
drift_exit_impulse = 70
cmd_setter("drift_exit_impulse", function(val) { drift_exit_impulse = val }, function() { return drift_exit_impulse })

is_drifting = false
drift_strength = 0

//current_tire_correction_force = 0
needed_velocity_x = 0
needed_velocity_y = 0
direction_x = 0
direction_y = 0

drift_particle_sys = part_system_create()
part_system_depth(drift_particle_sys, depth+1)
drift_part = part_type_create()
part_type_sprite(drift_part, drift, false, false, false)
part_type_alpha3(drift_part, 1, 1, 0)
part_type_life(drift_part, game_get_speed(gamespeed_fps) * 30, game_get_speed(gamespeed_fps) * 30)

garbage_stored = 0
max_garbage = 0 // Overridden by upgrade

damage = 0
max_damage = 0 // Overridden by upgrade
// create the camera that follows the player
instance_create_layer(0,0,layer,camera_obj)

//garbage collector
collector = instance_create_layer(x,y,layer,garbage_collector_obj)

function update_upgrades()
{
    var accel_in_km_per_h_per_s = global.upgrade_acceleration.acceleration_level[global.upgrade_acceleration.level]
    var accel_in_m_per_s_squared = km_per_hour_to_m_per_second(accel_in_km_per_h_per_s)
    gas_strength = accel_in_m_per_s_squared * phy_mass // F = ma
    
    var max_speed_km_per_h = global.upgrade_speed.speed_level[global.upgrade_speed.level]
    max_speed_meters_per_second = km_per_hour_to_m_per_second(max_speed_km_per_h)
    max_speed_force = get_force_for_speed(self, max_speed_meters_per_second)
    
    var break_in_km_per_h_per_s = global.upgrade_brakes.brakes_level[global.upgrade_brakes.level]
    var break_in_m_per_s_squared = km_per_hour_to_m_per_second(break_in_km_per_h_per_s)
    brake_strength = break_in_m_per_s_squared * phy_mass // F = ma
    
    max_turn_amount = global.upgrade_turn_radius.turn_level[global.upgrade_turn_radius.level]
    max_garbage = global.upgrade_capacity.capacity_level[global.upgrade_capacity.level]
    max_damage = global.upgrade_armour.armour_level[global.upgrade_armour.level]
}
update_upgrades()

function take_damage(_value)
{
	if(can_crash_again)
	{
        if not global.invincible
        {
            damage += _value
        }
		audio_play_sound(collision_sfx, 0, false)
		alarm[0] = 100
		can_crash_again = false
	}	
	move_speed /= 2
}

function increment_garbage(_value)
{
	if garbage_stored+_value <= max_garbage
	{
		garbage_stored += _value
		return true
	}
	return false
}

function collect_garbage()
{
	list = ds_list_create()
	with collector	
	{
		instance_place_list(x,y,garbage_obj,other.list,false)	
	}
	for (var i = 0; i < ds_list_size(list);i++)
	{
		var inst = ds_list_find_value(list,i)
		if increment_garbage(inst.collection_value)
		{
			audio_play_sound(pickup_sfx,0,false)
			instance_destroy(inst)	
		}
	}
	ds_list_destroy(list)
}

emitter = audio_emitter_create()
engine_sound = audio_play_sound_on(emitter,truck_sfx,true,0)

drift_emitter = audio_emitter_create()
drift_sound = audio_play_sound_on(drift_emitter,drift_sfx,true,0)
audio_emitter_gain(drift_emitter, 0)

alarm_set(1,2)