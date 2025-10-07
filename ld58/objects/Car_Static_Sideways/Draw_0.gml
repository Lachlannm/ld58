if(alarm[0] < 120 && car_state == 0)
{
	draw_sprite(sprite_index,-1, x, y + alarm[0]%2)
}
else
{
	draw_self()
}