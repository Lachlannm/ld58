function upgrade_speed(){
	if global.cash >= global.upgrade_speed.cost
	{
		global.upgrade_speed.level += 1
		global.cash -= global.upgrade_speed.cost
		global.upgrade_speed.cost += 50	
	}
}