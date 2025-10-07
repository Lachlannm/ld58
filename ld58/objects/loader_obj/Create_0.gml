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
// Upgrade levels initialize


global.upgrade_acceleration = {
	acceleration_level: [0.01, 0.011, 0.012, 0.013],
	cost: 50,
	level: 0,}
	
global.upgrade_armour = {
	armour_level: [6, 8, 10, 12],
	cost: 50,
	level: 0,}
	
global.upgrade_brakes = {
	brakes_level: [0.008, 0.012, 0.016, 0.020],
	cost: 50,
	level: 0,}
	
global.upgrade_speed = {
	speed_level: [3, 3.5, 4, 4.5],
	cost: 50,
	level: 0,}
	
global.upgrade_capacity = {
	capacity_level: [20, 25, 30, 35],
	cost: 50,
	level: 0,}
	
global.upgrade_turn_radius = {
	turn_level: [35, 37, 39, 41],
	cost: 50,
	level: 0,}

	


//after we are done, go to the main menu room
room_goto(menu_room)