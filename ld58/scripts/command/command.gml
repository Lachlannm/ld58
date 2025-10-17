function command() constructor{
	name = ""
	args = []
	action = function(_args)
	{
		return	
	}
	function usage_msg()
	{
		var msg = "usage: "
		for (var i = 0; i < array_length(self.args);i+=1)
		{
			var pattern = self.args[i].pattern
			switch pattern[0]
			{
				case "=" :
					msg += pattern[1] + " "
					break
				case ">=" :
					msg += "<" + pattern[2] + "> "
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
}