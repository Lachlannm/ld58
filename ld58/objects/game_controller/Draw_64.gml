draw_surface_ext(application_surface,0,0,1,1,0,colour,1)

for (var i = 0; i < player_obj.max_damage - player_obj.damage;i++)
{
	draw_sprite_ext(health_spr,0,i*64,0,2,2,0,c_white,1)
}


var center_screen_x = view_get_wport(0)/2
var center_screen_y = view_get_hport(0)/2

var seconds = string_format_zeroes(floor(time/60)%60,2,0)
var minutes = string_format_zeroes(floor(time/3600),2,0)
draw_set_halign(fa_left)
draw_text(50,75,string("Time Remaining: {0}:{1}",minutes,seconds))
draw_text(50,100,string("Garbage Stored: {0}/{1}",player_obj.garbage_stored,player_obj.max_garbage))

var speed_m_per_s = point_distance(0,0,player_obj.phy_linear_velocity_x, player_obj.phy_linear_velocity_y) / 10

draw_text(50,125,string("Speed: {0} km/h", m_per_second_to_km_per_hour(speed_m_per_s)))

if console
{
	var cursor = "_"
	if sin(cursor_time/7) >= 0
	{
		cursor = " "
	}
	draw_text(20,1000,"/"+keyboard_string+cursor+tab_completion_current_append)
	
    for (var i = 0; i < ds_list_size(global.console_output);i+=1)
	{
		draw_text(20,970-i*30,ds_list_find_value(global.console_output,i))
	}
}

//arrow to depot
if depot_distance > 300 and player_obj.garbage_stored > 0
{
    var color = c_white
    
    if player_obj.garbage_stored >= player_obj.max_garbage or time/60 < 30
    {
        // When garbage is full or 30 seconds left, flash it red
        
        var anim_progress = (depot_arrow_color_anim_frames % depot_arrow_color_anim_frames_duration) / depot_arrow_color_anim_frames_duration
        
        // Animate red on sin wave
        var red_amount = sin(anim_progress * 2*pi)
        
        var green_blue_amount = round((1-red_amount) * 255)
        
        color = make_color_rgb(255, green_blue_amount, green_blue_amount)
        
        depot_arrow_color_anim_frames++
    }
    else
    {
    	depot_arrow_color_anim_frames = 0
    }
    
	draw_set_halign(fa_center)
	draw_sprite_ext(arrow_spr,0,center_screen_x+lengthdir_x(400,depot_direction),center_screen_y+lengthdir_y(400,depot_direction),1,1,depot_direction,color,0.8)
	draw_text_color(center_screen_x+lengthdir_x(300,depot_direction),center_screen_y+lengthdir_y(300,depot_direction),"Garbage\nDropoff\n"+string(depot_distance/10)+"m",color,color,color,color,0.8)
}
else
{
    depot_arrow_color_anim_frames = 0
}