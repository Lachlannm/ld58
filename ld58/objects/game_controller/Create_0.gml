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
console_output = ds_list_create()
previous_commands = ds_list_create()
command_num = -1
cursor_time = 0
command_list = ds_map_keys_to_array(global.command_data)
command_amount = array_length(command_list)
menu_state = "none"
global.paused = 0

depot_distance = 0
depot_direction = 0

function console_command()
{
	var input = string_split(keyboard_string," ")
	keyboard_string = ""
	
	var closest_command = ""
	var closest_command_distance = 0
	var command_matches = 0
	
	//check for a command with matching signature to what is provided
	for (var i = 0; i < command_amount;i+=1)
	{
		var cmd = ds_map_find_value(global.command_data,command_list[i])
		var resolved_inputs = []
		
		//check each given arg to see if it matches the command signature
		for (var j = 0; j < array_length(input);j+=1)
		{
			var input_arg = input[j]
			var result = command_check(cmd.args[j],input_arg)
			if result == undefined
			{
				break
			}
			else
			{
				array_push(resolved_inputs,result)	
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
	
	return "error - incorrect command"
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
			else if cmd_arg.pattern[0] == "any"
			{
				if input_arg != ""
				{
					return input_arg	
				}
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
			return undefined
		case "any" :
			// any value is accepted, so assume it is ok to use
			return input_arg
	}
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