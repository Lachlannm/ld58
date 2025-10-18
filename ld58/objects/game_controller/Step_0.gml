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

if keyboard_check_pressed(ord("M")) and not console
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
	if keyboard_check_pressed(vk_enter) and array_length(tab_completion_list) == 0
	{
		ds_list_insert(global.previous_commands,0,keyboard_string)
		console_add_output(console_command())
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
    
    if keyboard_check_pressed(vk_tab)
    {
        if string_pos(" ", keyboard_string) == 0
        {
            apply_tab_completion(keyboard_string, ds_map_keys_to_array(global.command_data))
        }
        else
        {
        	var args = string_split(keyboard_string," ", true)
            var cmd = ds_map_find_value(global.command_data, args[0])
            
            if !is_undefined(cmd)
            {
                var arg_index = array_length(args) - 1
                var arg_value = args[arg_index]
                if string_ends_with(keyboard_string, " ")
                {
                    arg_index += 1
                    arg_value = ""
                }
                var tab_complete_options = cmd.tab_complete_list_callback(arg_index)
                if array_length(tab_complete_options) > 0
                {
                    apply_tab_completion(arg_value, tab_complete_options)
                }
            }
        }
    }
    else if tab_completion_list_index != -1 and
        (keyboard_check_pressed(vk_enter) or keyboard_check_pressed(vk_right) or keyboard_check_pressed(vk_space))
    {
        confirm_tab_completion()
    }
    else if keyboard_check_pressed(vk_anykey)
    {
        reset_tab_completion()
    }
}