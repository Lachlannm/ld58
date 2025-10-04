draw_self()
var colour = c_white
if is_drifting
{
	colour = c_red
}
draw_sprite_ext(wheel_spr,0,x+lengthdir_x(275,direction+17),y+lengthdir_y(275,direction+17),1,1,direction+turn_amount*max_turn_amount,colour,1)
draw_sprite_ext(wheel_spr,0,x+lengthdir_x(275,direction-17),y+lengthdir_y(275,direction-17),1,1,direction+turn_amount*max_turn_amount,colour,1)
draw_text(x,y,"move_speed = " + string(move_speed))
draw_text(x,y+40,"gas = " + string(gas_amount))
draw_text(x,y+80,"brake = " + string(brake_amount))
draw_text(x,y+120,"turn = " + string(turn_amount))
draw_text(x,y+160,"drifting = " + string(drift_amount))
