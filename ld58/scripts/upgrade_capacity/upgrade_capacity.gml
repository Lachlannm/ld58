function upgrade_capacity(){
	if global.cash >= global.upgrade_capacity.cost && global.upgrade_capacity.level < 3
	{
		global.upgrade_capacity.level += 1
		global.cash -= global.upgrade_capacity.cost
		global.upgrade_capacity.cost += 50
		audio_play_sound(upgrade_sfx, 0, false)
		show_debug_message("Capacity Upgraded")
	}
}