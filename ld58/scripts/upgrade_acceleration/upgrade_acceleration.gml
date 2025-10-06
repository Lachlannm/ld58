function upgrade_acceleration(){
	if global.cash >= global.upgrade_acceleration.cost && global.upgrade_acceleration.level < 3
	{
		global.upgrade_acceleration.level += 1
		global.cash -= global.upgrade_acceleration.cost
		global.upgrade_acceleration.cost += 50
		audio_play_sound(upgrade_sfx, 0, false)
		show_debug_message("Acceleration Upgraded")
	}
}