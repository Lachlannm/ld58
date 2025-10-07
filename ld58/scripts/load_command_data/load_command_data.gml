function load_command_data(){
	global.command_data = ds_map_create()
	var w
	
	//add commands here
	#region set_cash
	w = new command()
	w.name = "give_cash"
	w.args = [new command_arg("string","= set_cash"),
			  new command_arg("int64",">= 0 amount")]
	w.action = function(args)
	{
		var amount = args[1]
		global.cash += amount
		return string("cash set to {0}", global.cash)
	}
	ds_map_add(global.command_data,w.name,w)
	#endregion
    
    #region next_day
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
}