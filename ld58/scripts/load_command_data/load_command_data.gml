function load_command_data(){
	global.command_data = ds_map_create()
    global.variable_setters = ds_map_create()
    
	var w
	
	//add commands here
    
    #region help
	w = new command()
	w.name = "help"
	w.args = [new command_arg("string","= help"),
              new command_arg("string","optional command")]
	w.action = function(args)
	{
        if args[1] != "" and ds_map_exists(global.command_data, args[1])
        {
            return ds_map_find_value(global.command_data, args[1]).usage_msg()
        }
        return get_commands_string()
	}
	ds_map_add(global.command_data,w.name,w)
	#endregion
    
	#region give_cash
	w = new command()
	w.name = "give_cash"
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
	w.args = [new command_arg("string","= invincible"),
			  new command_arg("int64",">= 0 value")]
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
	ds_map_add(global.command_data,w.name,w)
	#endregion
    
    #region time
	w = new command()
	w.name = "time"
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
	}
	ds_map_add(global.command_data,w.name,w)
	#endregion
}

function cmd_setter(prop_name, set_callback)
{
    var w = new command()
	w.name = "set_" + prop_name
	w.args = [new command_arg("string","= set_" + prop_name),
			  new command_arg("number","any value")]
    
    var closure = // This is a workaround for no capturing in GML
    {
        prop_name: prop_name,
        set_callback: set_callback
    }
    var func = function(args)
    {
        set_callback(args[1])
        return "set " + string(prop_name) + " to " + string(args[1])
    }
    w.action = method(closure, func)
    
    ds_map_delete(global.command_data, w.name)
    ds_map_add(global.command_data,w.name,w)
}

function get_commands_string()
{
    var all_cmds = string_join_ext(", ", ds_map_keys_to_array(global.command_data))
    return "Available commands: " + all_cmds
}