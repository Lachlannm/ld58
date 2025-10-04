if time > 0
{
	time -= 1
	if time < 1800
	{
		colour = make_color_rgb(lerp(color_get_red(start_colour),color_get_red(end_colour),1-(time/1800)),
								lerp(color_get_green(start_colour),color_get_green(end_colour),1-(time/1800)),
								lerp(color_get_blue(start_colour),color_get_blue(end_colour),1-(time/1800)))
		
	}
}