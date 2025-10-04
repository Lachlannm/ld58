draw_surface_ext(application_surface,0,0,1,1,0,colour,1)

var seconds = string_format_zeroes(floor(time/60)%60,2,0)
var minutes = string_format_zeroes(floor(time/3600)%60,2,0)
draw_set_halign(fa_left)
draw_text(50,50,string("Time Remaining: {0}:{1}",minutes,seconds))
draw_text(50,75,string("Garbage Remaining: {0}",instance_number(garbage_obj)))

if console
{
	var cursor = "_"
	if sin(cursor_time/7) >= 0
	{
		cursor = ""	
	}
	draw_text(20,1000,"/"+keyboard_string+cursor)
	for (var i = 0; i < ds_list_size(console_output);i+=1)
	{
		draw_text(20,970-i*30,ds_list_find_value(console_output,i))	
	}
}