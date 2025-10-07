draw_surface_ext(application_surface,0,0,1,1,0,colour,1)

for (var i = 0; i < player_obj.max_damage - player_obj.damage;i++)
{
	draw_sprite_ext(health_spr,0,i*64,0,2,2,0,c_white,1)
}


var center_screen_x = view_get_wport(0)/2
var center_screen_y = view_get_hport(0)/2

var seconds = string_format_zeroes(floor(time/60)%60,2,0)
var minutes = string_format_zeroes(floor(time/3600)%60,2,0)
draw_set_halign(fa_left)
draw_text(50,75,string("Time Remaining: {0}:{1}",minutes,seconds))
draw_text(50,100,string("Garbage Stored: {0}/{1}",player_obj.garbage_stored,player_obj.max_garbage))

if console
{
	var cursor = "_"
	if sin(cursor_time/7) >= 0
	{
		cursor = ""	
	}
	draw_text(20,1000,"/"+keyboard_string+cursor)
	for (var i = 0; i < ds_list_size(console_output);i+=1)
	{
		draw_text(20,970-i*30,ds_list_find_value(console_output,i))	
	}
}

//arrow to depot
if depot_distance > 300
{
	draw_set_halign(fa_center)
	draw_sprite_ext(arrow_spr,0,center_screen_x+lengthdir_x(400,depot_direction),center_screen_y+lengthdir_y(400,depot_direction),1,1,depot_direction,c_white,0.8)
	draw_text_color(center_screen_x+lengthdir_x(300,depot_direction),center_screen_y+lengthdir_y(300,depot_direction),"Garbage\nDropoff\n"+string(depot_distance/10)+"m",c_white,c_white,c_white,c_white,0.8)
	
}