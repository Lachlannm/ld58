function upgrade_armour(){
	if global.cash >= global.upgrade_armour.cost && global.upgrade_armour.level < 3 
	{
		global.upgrade_armour.level += 1
		global.cash -= global.upgrade_armour.cost
		global.upgrade_armour.cost += 50
		audio_play_sound(upgrade_sfx, 0, false)
		show_debug_message("Armour Upgraded")
	}

}