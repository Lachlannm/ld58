//draw_self()

//physics_draw_debug()

var sprite_direction_id = floor( ((rotation_looped + 22.5) % 360)/45 )
var experimental_sprite_rotation = ((rotation_looped + 22.5) % 45) - 22.5
//draw_sprite(spr_directional_truck,sprite_direction_id,x,y-40)
draw_sprite_ext(spr_directional_truck,sprite_direction_id,x+lengthdir_x(20,rotation_looped),y+lengthdir_y(20,rotation_looped),1,1,experimental_sprite_rotation,c_white,1)
draw_sprite_ext(spr_directional_truck,sprite_direction_id,x+lengthdir_x(20,rotation_looped),y+lengthdir_y(20,rotation_looped),1,1,experimental_sprite_rotation,c_red,alarm_get(0)/100)

var colour = c_white

if is_drifting
{
	colour = c_red
}

//draw_sprite_ext(wheel_spr,0,x+lengthdir_x(45,rotation_looped+17),y+lengthdir_y(45,rotation_looped+17),1,1,rotation_looped+turn_amount*max_turn_amount,colour,1)
//draw_sprite_ext(wheel_spr,0,x+lengthdir_x(45,rotation_looped-17),y+lengthdir_y(45,rotation_looped-17),1,1,rotation_looped+turn_amount*max_turn_amount,colour,1)
//draw_sprite_ext(player_truck_alt,0,x,y,1,1,direction,c_white,1)
//draw_sprite_ext(player_truck_alt,0,x,y,1,1,direction,c_red,alarm_get(0)/100)


//var speed_in_meters_per_second = pixels_to_meters(point_distance(0,0,phy_linear_velocity_x, phy_linear_velocity_y))
//var my_phy_speed = meters_to_pixels(speed_in_meters_per_second) / game_get_speed(gamespeed_fps)
//draw_text(x-100,y,"phy_speed = " + string(phy_speed))
//draw_text(x-100,y+20,"my_phy_speed = " + string(my_phy_speed))
//draw_text(x-100,y+40,"speed_in_m/s = " + string(speed_in_meters_per_second))
//draw_text(x-100,y+60,"fps = " + string(game_get_speed(gamespeed_fps)))
//draw_text(x-100,y+20,"force_total = " + string(force_total))
//draw_text(x-100,y+40,"gas_amount = " + string(gas_amount))
//draw_text(x,y+40,"damage = " + string(damage))
//draw_text(x,y+20,"gas = " + string(gas_amount))
//draw_text(x,y+40,"brake = " + string(brake_amount))
//draw_text(x,y+60,"turn = " + string(turn_amount))
//draw_text(x,y+80,"drifting = " + string(drift_amount))
//draw_text(x,y+100,"centripital = " + string(centripital))