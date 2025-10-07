function upgrade_turn(){
	if global.cash >= global.upgrade_turn_radius.cost && global.upgrade_turn_radius.level < 3
	{
		global.upgrade_turn_radius.level += 1
		global.cash -= global.upgrade_turn_radius.cost
		global.upgrade_turn_radius.cost += 50
		audio_play_sound(upgrade_sfx, 0, false)
		show_debug_message("Turn Radius Upgraded")
	}
}