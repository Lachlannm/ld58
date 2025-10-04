///@desc Converts a real number into a zero-padded string, where you can specify how many digits are visible on each side of the decimal. 
///@param {real} _val The real number to be converted to a string.
///@param {real} _tot The number of places of the main number to be shown (left side of decimal).
///@param {real} _dec The number of decimal places to be included (right side of decimal).
function string_format_zeroes(_val, _tot, _dec){
	var str = string_format(_val,_tot,_dec)
	return string_replace(str," ","0")
}