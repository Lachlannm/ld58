physics_mass_properties(phy_mass, 0, 0, phy_inertia)

test_project_vector()

pixels_per_meter = 10
frames_per_second = 60

gas_rate = 0.015
gas_amount = 0
gas_strength = global.upgrade_acceleration.acceleration_level[global.upgrade_acceleration.level]

// To upgrade the speed we need to reduce the linear damping
phy_linear_damping = global.upgrade_speed.speed_level[global.upgrade_speed.level]

brake_rate = 0.02
brake_amount = 0
brake_strength = global.upgrade_brakes.brakes_level[global.upgrade_brakes.level]

force_total = 0

move_speed = 0

//nathaniel edit
max_reverse_speed = -0.5
can_crash_again = true
//end edit

turn_speed = 0.1
turn_amount = 0
turn_rate = 0.02
max_turn_amount = global.upgrade_turn_radius.turn_level[global.upgrade_turn_radius.level]

rotation_looped = 0

// Max force the tires apply before start slipping to enter drift
tire_max_correction_force = 10
// The tire correction force applied while drifting
// Much lower so it feels like you're slipping
tire_correction_force_drifting = 3
// The minimum calculated force you can reach before exiting drift
tire_min_correction_force_exit_drift = 7

// The rate at which the drift strength increases while drifting (per frame)
drift_rate = 0.01
// These are used to tell how the drift affects the gas power
drift_gas_constant_multiplier = 0.5
drift_gas_multiply_by_strength = 4

// This is the boost that is received when exiting,
//  multiplied by current drift_strength
drift_exit_impulse = 70

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
part_type_life(drift_part, 1000, 1000)

garbage_stored = 0
max_garbage = global.upgrade_capacity.capacity_level[global.upgrade_capacity.level]

damage = 0
max_damage = global.upgrade_armour.armour_level[global.upgrade_armour.level]
// create the camera that follows the player
instance_create_layer(0,0,layer,camera_obj)

//garbage collector
collector = instance_create_layer(x,y,layer,garbage_collector_obj)

function take_damage(_value)
{
	if(can_crash_again)
	{
		damage += _value
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
brake_held = false
alarm_set(1,2)