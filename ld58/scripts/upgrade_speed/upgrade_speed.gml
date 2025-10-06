function upgrade_speed(){
	if global.cash >= global.upgrade_speed.cost && global.upgrade_speed.level < 3
	{
		global.upgrade_speed.level += 1
		global.cash -= global.upgrade_speed.cost
		global.upgrade_speed.cost += 50
		audio_play_sound(upgrade_sfx, 0, false)
		show_debug_message("Speed Upgraded")
	}
}