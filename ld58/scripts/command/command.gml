function command() constructor{
	name = ""
    description = "Do something."
	args = []
	action = function(_args)
	{
		return	string(array_length(_args))
	}
	function usage_msg()
	{
		var msg = "Usage:\n"
		for (var i = 0; i < array_length(self.args);i+=1)
		{
			var pattern = self.args[i].pattern
			switch pattern[0]
			{
				case "=" :
					msg += pattern[1] + " "
					break
				case ">=" :
					msg += "<" + pattern[2] + " >= " + string(pattern[1]) + "> "
					break
				case "any" :
					msg += "<" + pattern[1] + "> "
					break
				case "optional" :
					msg += "[" + pattern[1] + "] "
					break
			}
		}
		return msg
	}
	tab_complete_list_callback = function(_arg_num)
	{
        var next_arg = _arg_num + 1
		return	[]
	}
}