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
global.invincible = 0

global.console_output = ds_list_create()
global.previous_commands = ds_list_create()


// Upgrade levels initialize

global.upgrades_by_name = ds_map_create()

global.upgrade_acceleration = {
    // Acceleration in km/h per second
	acceleration_level: [6, 6.6, 7.2, 8],
	cost: 50,
	level: 0,}
ds_map_add(global.upgrades_by_name, "acceleration", global.upgrade_acceleration)


global.upgrade_armour = {
	armour_level: [6, 8, 10, 12],
	cost: 50,
	level: 0,}
ds_map_add(global.upgrades_by_name, "armour", global.upgrade_armour)
	
global.upgrade_brakes = {
	brakes_level: [20, 25, 30, 35],
	cost: 50,
	level: 0,}
ds_map_add(global.upgrades_by_name, "brakes", global.upgrade_brakes)
	
global.upgrade_speed = {
    // Max speed in km/h
	speed_level: [40, 46, 53, 60],
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