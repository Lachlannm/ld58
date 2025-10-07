gas_rate = 0.015
gas_amount = 0
gas_strength = 0.01

brake_rate = 0.02
brake_amount = 0
brake_strength = 0.008

move_speed = 0
max_speed = 3

//nathaniel edit
max_reverse_speed = -0.5
can_crash_again = true
//end edit

turn_speed = 0.1
turn_amount = 0
turn_rate = 0.02
max_turn_amount = 35

move_drag = gas_strength/max_speed
drag = 0.005

drift_amount = 0
drift_rate = 0.2
drift_start_threshold = 1.8
drift_start_speed = 2.1
drift_stop_threshold = 1.7
drift_stop_speed = 1.8
drift_exit_boost = 0.3
is_drifting = false
centripital = 0

drift_particle_sys = part_system_create()
part_system_depth(drift_particle_sys, 150)
drift_part = part_type_create()
part_type_sprite(drift_part, drift, false, false, false)
part_type_life(drift_part, 1000, 1000)

garbage_stored = 0
max_garbage = 20

damage = 0
max_damage = 6
can_crash_again = true
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
//Upgrade stats
brake_strength = global.upgrade_brakes.brakes_level[global.upgrade_brakes.level]
gas_strength = global.upgrade_acceleration.acceleration_level[global.upgrade_acceleration.level]
max_damage = global.upgrade_armour.armour_level[global.upgrade_armour.level]
max_speed = global.upgrade_speed.speed_level[global.upgrade_speed.level]
max_garbage = global.upgrade_capacity.capacity_level[global.upgrade_capacity.level]
max_turn_amount = global.upgrade_turn_radius.turn_level[global.upgrade_turn_radius.level]
emitter = audio_emitter_create()
engine_sound = audio_play_sound_on(emitter,truck_sfx,true,0)
brake_held = false
alarm_set(1,2)