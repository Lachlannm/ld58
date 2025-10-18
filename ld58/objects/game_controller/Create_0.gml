global.garbage_deposited = 0
if !audio_is_playing(music)
{
	audio_play_sound(music,0,true)
}
//Create some garbage
total_garbage_ratio = clamp(0.2 + global.day*0.1, 0, 1)

garbage_layer = layer_create(-100,"garbage_lyr")
garbage_spawnpoints = []
num_garbage_spawnpoints = instance_number(garbage_spawnpoint_obj)
num_garbage_to_spawn = clamp(floor(total_garbage_ratio * num_garbage_spawnpoints), 0, num_garbage_spawnpoints)

for(var i = 0; i < num_garbage_spawnpoints; i++)
{
	array_push(garbage_spawnpoints, instance_find(garbage_spawnpoint_obj, i))
}

garbage_spawnpoints = array_shuffle(garbage_spawnpoints)

for(var i = 0; i < num_garbage_to_spawn; i++)
{
	var spawnpoint = array_pop(garbage_spawnpoints)
	instance_create_layer(spawnpoint.x,spawnpoint.y,"Instances",garbage_obj)
}
instance_destroy(garbage_spawnpoint_obj)

time = 7200
colour = c_white
start_colour = c_white
end_colour = make_color_rgb(70,50,60)

console = false
command_num = -1
cursor_time = 0
command_list = ds_map_keys_to_array(global.command_data)
command_amount = array_length(command_list)
menu_state = "none"
global.paused = 0

depot_distance = 0
depot_direction = 0

// Somewhat arbitrary / guesswork without fixed width font
console_char_width = 150
function console_add_output(output_string)
{
    var output_string_lines = string_split(output_string, "\n")
    for (var output_line_num = 0; output_line_num < array_length(output_string_lines); output_line_num++)
    {
        var current_output_string = output_string_lines[output_line_num]
        
        var length_remaining = string_length(current_output_string)
        while (length_remaining > console_char_width)
        {
            var current_line = string_copy(current_output_string, 1, console_char_width)
            ds_list_insert(global.console_output, 0, current_line)
            
            length_remaining -= console_char_width
            current_output_string = string_copy(current_output_string, console_char_width + 1, length_remaining)
        }
        ds_list_insert(global.console_output, 0, current_output_string)
    }
}

function console_command()
{
	var input = string_split(keyboard_string," ", true)
	keyboard_string = ""
	
	var closest_command = ""
	var closest_command_distance = 0
	var command_matches = 0
	
	//check for a command with matching signature to what is provided
	for (var i = 0; i < command_amount;i+=1)
	{
		var cmd = ds_map_find_value(global.command_data,command_list[i])
		var resolved_inputs = []
		var has_invalid_param = false
        
		//check each given arg to see if it matches the command signature
		for (var j = 0; j < array_length(input) and j < array_length(cmd.args);j+=1)
		{
			var input_arg = input[j]
			var result = command_check(cmd.args[j],input_arg)
			if result == undefined
			{
                has_invalid_param = true
				break
			}
			else
			{
				array_push(resolved_inputs,result)	
			}
		}
        
        if not has_invalid_param
        {
            for (var j = array_length(input); j < array_length(cmd.args); j++)
            {
                show_debug_message("extra cmd param pattern: {0}", cmd.args[j].pattern[0])
                if cmd.args[j].pattern[0] == "optional"
                {
                    show_debug_message("Adding empty optional param")
                    if cmd.args[j].type == "string"
                    {
                        array_push(resolved_inputs,"")
                    }
                    else
                    { // Is a number or int64, defaults to undefined
                        array_push(resolved_inputs, undefined)
                    }
                }
                else
                {
                	break
                }
            }
        }
        
		
		//check if the number of resolved inputs match the command
		if array_length(cmd.args) != array_length(resolved_inputs)
		{
			//check if this command is closer to the given input than any previous ones
			//for displaying help info later on
			if array_length(resolved_inputs) > closest_command_distance
			{
				closest_command_distance = array_length(resolved_inputs)
				closest_command = cmd.name
			}
			continue
		}
        
		show_debug_message("expected args: {0}", cmd.args)
		show_debug_message("executing with args: {0}", resolved_inputs)
		//all arguments are valid, now execute the command
		var output = cmd.action(resolved_inputs)
		return output
	}
	
	//show help info since we matched at least one argument
	if closest_command != ""
	{
		var cmd = ds_map_find_value(global.command_data,closest_command)
		return cmd.usage_msg()
	}
	
	return get_commands_string()
}

function command_check(cmd_arg,input_arg)
{
	var num
	switch cmd_arg.type
	{
		case "string" :
			if cmd_arg.pattern[0] == "="
			{
				if input_arg == cmd_arg.pattern[1]
				{
					return input_arg
				}
			}
			else if cmd_arg.pattern[0] == "any" or cmd_arg.pattern[0] == "optional"
			{
                return input_arg
			}
			return undefined
		case "int64" : 
			// try to convert to int64
			num = to_int64(input_arg)
			if num == undefined
			{
				return undefined
			}
			
			if cmd_arg.pattern[0] == ">="
			{
				if num >= cmd_arg.pattern[1]
				{
					return num	
				}
			}
        
			if cmd_arg.pattern[0] == "any" or cmd_arg.pattern[0] == "optional"
			{
                return num
			}
			return undefined
		case "number" :
			// try to convert to int64
			num = to_real(input_arg)
			if num == undefined
			{
				return undefined
			}
			
			if cmd_arg.pattern[0] == ">="
			{
				if num >= cmd_arg.pattern[1]
				{
					return num	
				}
			}
			
			if cmd_arg.pattern[0] == "any" or cmd_arg.pattern[0] == "optional"
			{
                return num
			}
			return undefined
		case "any" :
			// any value is accepted, so assume it is ok to use
			return input_arg
	}
}

tab_completion_partial_value = ""
tab_completion_current_append = ""
tab_completion_list = []
tab_completion_list_index = -1
function apply_tab_completion(partial_value, possible_values_array)
{
    var is_first_tab_complete = tab_completion_list_index == -1
    
    tab_completion_partial_value = partial_value
    
    if array_length(tab_completion_list) == 0
    {
        // Get all matches
        var sorted_values = []
        array_copy(sorted_values, 0, possible_values_array, 0, array_length(possible_values_array))
        array_sort(sorted_values, true)
        
        for (var i = 0; i < array_length(sorted_values); i++)
        {
            if string_starts_with(sorted_values[i], tab_completion_partial_value)
            {
                array_push(tab_completion_list, sorted_values[i])
            }
        }
        
        // Find longest common beginning, to aid in typing more quickly,
        //  but don't bother if there's only one match
        if array_length(tab_completion_list) > 1
        {
            var longest_shared_start = tab_completion_partial_value
            var mismatch = false
            
            while (not mismatch)
            {
                var next_char = string_char_at(tab_completion_list[0], string_length(longest_shared_start)+1)
                var next_shared_start = longest_shared_start + next_char
                
                for (var i = 0; i < array_length(tab_completion_list); i++)
                {
                    if not string_starts_with(tab_completion_list[i], next_shared_start)
                    {
                        mismatch = true
                        break
                    }
                }
                
                if not mismatch
                {
                    longest_shared_start = next_shared_start
                }
            }
            
            var to_add = string_replace(longest_shared_start, tab_completion_partial_value, "")
            keyboard_string += to_add
            tab_completion_partial_value = longest_shared_start
        }
    }
    
    if array_length(tab_completion_list) > 0
    {
        tab_completion_list_index = (tab_completion_list_index + 1) % array_length(tab_completion_list)
        
        var starting_index = string_length(tab_completion_partial_value) + 1
        var completion_value = tab_completion_list[tab_completion_list_index]
        var sub_length = string_length(completion_value) - (starting_index-1)
        tab_completion_current_append = string_copy(completion_value, starting_index, sub_length)
        
        if array_length(tab_completion_list) == 1
        {
            confirm_tab_completion()
            return
        }
        
        if is_first_tab_complete
        {
            values_str = string_join_ext(", ", tab_completion_list)
            console_add_output("Possible completions:")
            console_add_output(values_str)
        }
    }
}

function confirm_tab_completion()
{
    keyboard_string += tab_completion_current_append + " "
    reset_tab_completion()
}

function reset_tab_completion()
{
    show_debug_message("reset_tab_completion")
    tab_completion_partial_value = ""
    tab_completion_current_append = ""
    tab_completion_list = []
    tab_completion_list_index = -1
}

function end_day()
{
	global.cash += global.garbage_deposited * 5
	global.garbage_deposited = 0
	global.day += 1
	if player_obj.damage == player_obj.max_damage
	{
		room_goto(game_over)
	}
	else
	{
		room_goto(upgrade_room)
	}
}