if player_obj.garbage_stored > 0
{
	global.garbage_deposited += player_obj.garbage_stored

	audio_play_sound(dropoff_sfx, 0, false)
	instance_create_layer(x+32,y+32,"upper_instances",garbage_text,{amount: player_obj.garbage_stored})
	player_obj.garbage_stored = 0
}