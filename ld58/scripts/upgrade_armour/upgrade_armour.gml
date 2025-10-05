function upgrade_armour(){
	if global.cash >= global.upgrade_armour.cost
	{
		global.upgrade_armour.level += 1
		global.cash -= global.upgrade_armour.cost
		global.upgrade_armour.cost += 50
	}

}