if(alarm[0] < 120 && car_state == CarState.Idle_Origin)
{
	
	draw_sprite(sprite_index,-1, x, y + alarm[0]%2)
}
else
{
	draw_self()
}