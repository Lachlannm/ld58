function upgrade_acceleration(){
	if global.cash >= global.upgrade_acceleration.cost
	{
		global.upgrade_acceleration.level += 1
		global.cash -= global.upgrade_acceleration.cost
		global.upgrade_acceleration.cost += 50
	}
}