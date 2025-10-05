function upgrade_brakes(){
	if global.cash >= global.upgrade_brakes.cost && global.upgrade_brakes.level < 3
	{
		global.upgrade_brakes.level += 1
		global.cash -= global.upgrade_brakes.cost
		global.upgrade_brakes.cost += 50
		show_debug_message("Brakes Upgraded")
	}

}