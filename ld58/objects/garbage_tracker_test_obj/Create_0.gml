//get a list of all garbage-spawning points in the area
//select a random one from the list and make it spawn a piece of garbage, then remove it from the list
//repeat this for the total number of garbage determined from the ratio given in the variable definition

garbage_spawnpoints = []
num_garbage_spawnpoints = instance_number(garbage_spawnpoint_obj)
num_garbage_to_spawn = floor(total_garbage_ratio * num_garbage_spawnpoints)

for(var i = 0; i < num_garbage_spawnpoints; i++)
{
	array_push(garbage_spawnpoints, instance_find(garbage_spawnpoint_obj, i))
}

garbage_spawnpoints = array_shuffle(garbage_spawnpoints)

for(var i = 0; i < num_garbage_to_spawn; i++)
{
	var spawnpoint = array_pop(garbage_spawnpoints)
	spawnpoint.spawn()
}