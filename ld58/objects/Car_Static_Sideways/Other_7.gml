if(sprite_index == spr_explosion)
{
	instance_create_layer(x,y,"Instances",wreck_obj)
	instance_destroy()
}