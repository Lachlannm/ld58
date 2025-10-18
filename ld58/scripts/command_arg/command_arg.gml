function command_arg(_type,_pattern) constructor{
	type = _type
	pattern = string_split(_pattern," ")
	if type == "number" and pattern[0] != "any"
	{
		pattern[1] = real(pattern[1])	
	}
	else if type == "int64"
	{
		pattern[1] = int64(pattern[1])	
	}
}