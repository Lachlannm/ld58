//Create some garbage
garbage_layer = layer_create(-100,"garbage_lyr")
for (var i=0; i<initial_garbage_count; i++)
{
	var x_coord = random_range(0,room_width);
	var y_coord = random_range(0,room_height);
	instance_create_layer(x_coord, y_coord, garbage_layer, garbage_obj);
}

time = 2000
colour = c_white
start_colour = c_white
end_colour = make_color_rgb(70,50,60)