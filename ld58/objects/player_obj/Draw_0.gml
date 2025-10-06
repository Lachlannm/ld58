draw_self()
var colour = c_white
if is_drifting
{
	colour = c_red
}
draw_sprite_ext(wheel_spr,0,x+lengthdir_x(45,-phy_rotation+17),y+lengthdir_y(45,-phy_rotation+17),1,1,-phy_rotation+turn_amount*max_turn_amount,colour,1)
draw_sprite_ext(wheel_spr,0,x+lengthdir_x(45,-phy_rotation-17),y+lengthdir_y(45,-phy_rotation-17),1,1,-phy_rotation+turn_amount*max_turn_amount,colour,1)
draw_text(x-100,y,"phy_speed = " + string(phy_speed))
draw_text(x-100,y+20,"move_force_current = " + string(move_force_current))
draw_text(x-100,y+40,"turn_amount = " + string(turn_amount))
draw_text(x-100,y+60,"rotation = " + string(rotation))
draw_text(x-100,y+80,"garbage = " + string(garbage_stored))
draw_text(x-100,y+100,"damage = " + string(damage))


sprite_direction_id = floor( ((phy_rotation + 22.5) % 360)/45 )
var experimental_sprite_rotation = ((phy_rotation + 22.5) % 45) - 22.5
//draw_sprite(spr_directional_truck,sprite_direction_id,x,y-40)
//draw_sprite_ext(spr_directional_truck,sprite_direction_id,x,y,1,1,experimental_sprite_rotation,c_white,1)
