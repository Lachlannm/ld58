if car_state != 4
{
	max_speed = 0
	speed = 0
	sprite_index = spr_explosion
	audio_play_sound(explode_sfx, 0, false)
	car_state = 4
	other.take_damage(1)
}