// here we initialize any globals we are using and do any first time setup stuff
randomize()
load_command_data()

enum CarState
{
	Idle_Origin = 0,
	Advancing,
	Idle_Advanced,
	Retreating,
	Dead
}

global.cash = 0
global.garbage_deposited = 0
global.day = 0
global.enable_sound = true
global.invincible = 0

global.console_output = ds_list_create()
global.previous_commands = ds_list_create()


// Upgrade levels initialize

global.upgrades_by_name = ds_map_create()

global.upgrade_acceleration = {
	acceleration_level: [0.01, 0.011, 0.012, 0.013],
	cost: 50,
	level: 0,}
ds_map_add(global.upgrades_by_name, "acceleration", global.upgrade_acceleration)


global.upgrade_armour = {
	armour_level: [6, 8, 10, 12],
	cost: 50,
	level: 0,}
ds_map_add(global.upgrades_by_name, "armour", global.upgrade_armour)
	
global.upgrade_brakes = {
	brakes_level: [0.008, 0.012, 0.016, 0.020],
	cost: 50,
	level: 0,}
	
global.upgrade_speed = {
	speed_level: [0.05, 0.04, 0.035, 0.03],
	cost: 50,
	level: 0,}
ds_map_add(global.upgrades_by_name, "speed", global.upgrade_speed)
	
global.upgrade_capacity = {
	capacity_level: [20, 25, 30, 35],
	cost: 50,
	level: 0,}
ds_map_add(global.upgrades_by_name, "capacity", global.upgrade_capacity)
	
global.upgrade_turn_radius = {
	turn_level: [35, 37, 39, 41],
	cost: 50,
	level: 0,}
ds_map_add(global.upgrades_by_name, "turn_radius", global.upgrade_turn_radius)



//after we are done, go to the main menu room
room_goto(menu_room)