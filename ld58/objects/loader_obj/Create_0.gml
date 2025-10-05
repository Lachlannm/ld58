// here we initialize any globals we are using and do any first time setup stuff
randomize()
load_command_data()

global.cash = 0
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
	

	


//after we are done, go to the main menu room
room_goto(menu_room)