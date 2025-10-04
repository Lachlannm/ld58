for (var i=0; i<initial_garbage_count; i++)
{
	var x_coord = random_range(0,room_width);
	var y_coord = random_range(0,room_height);
	instance_create_layer(x_coord, y_coord, "garbage_obj_" + string(i), garbage_obj);
}