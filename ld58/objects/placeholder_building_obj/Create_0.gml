//Pick a random building
var sprite_names = [
	house_spr, 
	house2_spr, 
	house3_spr
];
sprite_index = sprite_names[irandom_range(0, array_length(sprite_names) - 1)];

layer = layer_get_id("upper_instances")