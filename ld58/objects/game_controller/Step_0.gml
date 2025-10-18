if time > 0
{
	time -= 1
	if time < 1800
	{
		colour = make_color_rgb(lerp(color_get_red(start_colour),color_get_red(end_colour),1-(time/1800)),
								lerp(color_get_green(start_colour),color_get_green(end_colour),1-(time/1800)),
								lerp(color_get_blue(start_colour),color_get_blue(end_colour),1-(time/1800)))
		
	}
}
else 
{
    end_day()
}

depot_distance = point_distance(player_obj.x,player_obj.y,dropoff_obj.x,dropoff_obj.y)
depot_direction = point_direction(player_obj.x,player_obj.y,dropoff_obj.x,dropoff_obj.y)

// pause menu
if keyboard_check_pressed(vk_escape)
{
	if menu_state == "none"
	{
		global.paused = 1	
		menu_state = "paused"
	}
	else if menu_state == "paused"
	{
		global.paused = 0	
		menu_state = "none"
	}
	else if menu_state == "console"
	{
		global.paused = 0
		console = false
		menu_state = "none"
	}
}

if keyboard_check_pressed(vk_f11)
{
	window_set_fullscreen(!window_get_fullscreen())	
}

if keyboard_check_pressed(ord("M"))
{
	global.enable_sound = !global.enable_sound
	if !global.enable_sound
	{
		audio_set_master_gain(0,0)
	}
	else
	{
		audio_set_master_gain(0,1)
	}
}

//console
if keyboard_check_pressed(191)
{
	if menu_state == "none"
	{
		console = true
		global.paused = 1
		keyboard_string = ""
		menu_state = "console"
	}
}

if console
{
	cursor_time += 1
	if keyboard_check_pressed(vk_enter)
	{
		ds_list_insert(global.previous_commands,0,keyboard_string)
		ds_list_insert(global.console_output,0,console_command())
		command_num = -1
	}
	
	if keyboard_check_pressed(vk_up) and ds_list_size(global.previous_commands) > 0
	{
		command_num = clamp(command_num+1,0,ds_list_size(global.previous_commands)-1)
		keyboard_string = ds_list_find_value(global.previous_commands,command_num)
	}
	
	if keyboard_check_pressed(vk_down) and ds_list_size(global.previous_commands) > 0
	{
		command_num = clamp(command_num-1,0,ds_list_size(global.previous_commands)-1)
		keyboard_string = ds_list_find_value(global.previous_commands,command_num)
	}
    
    if keyboard_check_pressed(191)
    {
        keyboard_string = string_delete(keyboard_string, string_length(keyboard_string), 1);
    }
}