//draw_self()
//var colour = c_white
//if is_drifting
//{
//	colour = c_red
//}
//draw_sprite_ext(wheel_spr,0,x+lengthdir_x(45,direction+17),y+lengthdir_y(45,direction+17),1,1,direction+turn_amount*max_turn_amount,colour,1)
//draw_sprite_ext(wheel_spr,0,x+lengthdir_x(45,direction-17),y+lengthdir_y(45,direction-17),1,1,direction+turn_amount*max_turn_amount,colour,1)
//draw_text(x,y,"move_speed = " + string(move_speed))
//draw_text(x,y+20,"garbage = " + string(garbage_stored))
//draw_text(x,y+40,"damage = " + string(damage))
//draw_text(x,y+20,"gas = " + string(gas_amount))
//draw_text(x,y+40,"brake = " + string(brake_amount))
//draw_text(x,y+60,"turn = " + string(turn_amount))
//draw_text(x,y+80,"drifting = " + string(drift_amount))
//draw_text(x,y+100,"centripital = " + string(centripital))

var sprite_direction_id = floor( ((direction + 22.5) % 360)/45 )
var experimental_sprite_rotation = ((direction + 22.5) % 45) - 22.5
//draw_sprite(spr_directional_truck,sprite_direction_id,x,y-40)
draw_sprite_ext(spr_directional_truck,sprite_direction_id,x+lengthdir_x(20,direction),y+lengthdir_y(20,direction),1,1,experimental_sprite_rotation,c_white,1)
draw_sprite_ext(spr_directional_truck,sprite_direction_id,x+lengthdir_x(20,direction),y+lengthdir_y(20,direction),1,1,experimental_sprite_rotation,c_red,alarm_get(0)/100)

//draw_sprite_ext(player_truck_alt,0,x,y,1,1,direction,c_white,1)
//draw_sprite_ext(player_truck_alt,0,x,y,1,1,direction,c_red,alarm_get(0)/100)
