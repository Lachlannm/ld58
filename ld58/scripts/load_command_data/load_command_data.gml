function load_command_data(){
	global.command_data = ds_map_create()
    global.variable_setters = ds_map_create()
    global.variable_getters = ds_map_create()
    
	var w
	
	//add commands here
    
    #region help
	w = new command()
	w.name = "help"
	w.description = "Show all commands, or descriptions for specific ones"
	w.args = [new command_arg("string","= help"),
              new command_arg("string","optional command")]
	w.action = function(args)
	{
        if args[1] != "" and ds_map_exists(global.command_data, args[1])
        {
            var cmd = ds_map_find_value(global.command_data, args[1])
            return cmd.usage_msg() + "\n" +
                    "Description:\n" +
                    cmd.description
        }
        return get_commands_string()
	}
    w.tab_complete_list_callback = function(_arg_num)
    {
        if _arg_num == 1
        {
            return ds_map_keys_to_array(global.command_data)
        }
        return []
    }
	ds_map_add(global.command_data,w.name,w)
	#endregion
    
	#region give_cash
	w = new command()
	w.name = "give_cash"
	w.description = "Add cash to your total"
	w.args = [new command_arg("string","= give_cash"),
			  new command_arg("int64",">= 0 amount")]
	w.action = function(args)
	{
		var amount = args[1]
		global.cash += amount
		return string("cash set to {0}", global.cash)
	}
	ds_map_add(global.command_data,w.name,w)
	#endregion
    
    #region end_day
	w = new command()
	w.name = "end_day"
	w.args = [new command_arg("string","= end_day")]
	w.action = function(args)
	{
		game_controller.end_day()
        return string("end of day")
	}
	ds_map_add(global.command_data,w.name,w)
	#endregion
    
    
    #region invincible
	w = new command()
	w.name = "invincible"
	w.description = "Set to 1 to make yourself invincible.\n" +
                    "Damage sound and animation still plays."
	w.args = [new command_arg("string","= invincible"),
			  new command_arg("int64","any 0|1")]
	w.action = function(args)
	{
        global.invincible = args[1]
        if args[1]
        {
            return string("turned invincibility on")
        }
        else
        {
            return string("turned invincibility off")
        }
	}
	ds_map_add(global.command_data,w.name,w)
	#endregion
    
    #region upgrade
	w = new command()
	w.name = "upgrade"
	w.description = "Set the level of any upgrade.\n" +
                    "Currently the max level is 3."
	w.args = [new command_arg("string","= upgrade"),
              new command_arg("string","any upgrade_name"),
			  new command_arg("int64",">= 0 value")]
	w.action = function(args)
	{
        var upgrade = ds_map_find_value(global.upgrades_by_name, args[1])
        if is_undefined(upgrade)
        {
            return string("Invalid upgrade, possible values: {0}", string_join_ext(", ", ds_map_keys_to_array(global.upgrades_by_name)))
        }
        
        upgrade.level = args[2]
        player_obj.update_upgrades()
	}
    w.tab_complete_list_callback = function(_arg_num)
    {
        if _arg_num == 1
        {
            return ds_map_keys_to_array(global.upgrades_by_name)
        }
        return []
    }
	ds_map_add(global.command_data,w.name,w)
	#endregion
    
    #region time
	w = new command()
	w.name = "time"
	w.description = "Set the current time remaining.\n" +
                    "Format is in mm:ss, but handles some invalid values still."
	w.args = [new command_arg("string","= time"),
			  new command_arg("string","any mm:ss")]
	w.action = function(args)
	{
        var time_str = args[1]
        var time_split = string_split(args[1], ":")
        if array_length(time_split) != 2
        {
            return "The time value must be of the form mm:ss"
        }
        
        var minutes = to_int64(time_split[0])
        var seconds = to_int64(time_split[1])
        
        if is_undefined(minutes) or is_undefined(seconds)
        {
            return "The minutes and seconds must be numbers"
        }
        if minutes < 0 or seconds < 0
        {
            return "The minutes and seconds must not be negative"
        }
        var minute_ticks = minutes * 60 * 60 // 60 FPS and 60 S/minute
        var second_ticks = seconds * 60 // 60 FPS
        game_controller.time = minute_ticks + second_ticks
        
        var seconds_output = string_format_zeroes(floor(game_controller.time/60)%60,2,0)
        var minutes_output = string_format_zeroes(floor(game_controller.time/3600),2,0)
        
        return "Set time remaining to " + minutes_output + ":" + seconds_output
	}
    w.tab_complete_list_callback = function(_arg_num)
    {
        if _arg_num == 1
        {
            return ["100:00"]
        }
        return []
    }
	ds_map_add(global.command_data,w.name,w)
	#endregion
    
    #region var
	w = new command()
	w.name = "var"
	w.description = "Set/get registered variable values.\n" +
                    "If value is not provided, will output current value.\n" +
                    "Use 'var list' to see all registered variables."
	w.args = [new command_arg("string","= var"),
			  new command_arg("string","any variable_name|list"),
			  new command_arg("number","optional value")]
	w.action = function(args)
	{
        if args[1] == "list"
        {
            return "Available variables:\n" +
                    string_join_ext(", ", ds_map_keys_to_array(global.variable_setters))
        }
        
        var setter_callback = ds_map_find_value(global.variable_setters, args[1])
        var getter_callback = ds_map_find_value(global.variable_getters, args[1])
        
        if is_undefined(setter_callback)
        {
            return "Invalid variable_name, try 'var list' for a list of all variables"
        }
        
        if is_undefined(args[2])
        {
            return args[1] + " = " + string(getter_callback())
        }
        
        setter_callback(args[2])
        
        return "set variable: " + args[1] + " = " + string(args[2])
	}
    w.tab_complete_list_callback = function(_arg_num)
    {
        if _arg_num == 1
        {
            return ds_map_keys_to_array(global.variable_setters)
        }
        return []
    }
	ds_map_add(global.command_data,w.name,w)
	#endregion
}

function cmd_setter(prop_name, set_callback, get_callback)
{
    ds_map_delete(global.variable_setters, prop_name)
    ds_map_add(global.variable_setters,prop_name,set_callback)
    
    ds_map_delete(global.variable_getters, prop_name)
    ds_map_add(global.variable_getters,prop_name,get_callback)
}

function get_commands_string()
{
    var all_cmds = string_join_ext(", ", ds_map_keys_to_array(global.command_data))
    return "Available commands:\n" + all_cmds
}