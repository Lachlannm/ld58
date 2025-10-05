//Populate (total_ratio * 100)% of the given spawn points at random
function object_spawn(spawnpoint_obj, total_ratio, object_to_spawn){
    var spawnpoints = []
    var num_spawnpoints = instance_number(spawnpoint_obj)
    var num_to_spawn = floor(total_ratio * num_spawnpoints)
    
    for(var i = 0; i < num_spawnpoints; i++)
    {
        array_push(spawnpoints, instance_find(spawnpoint_obj, i))
    }
    
    spawnpoints = array_shuffle(spawnpoints)
    
    for(var i = 0; i < num_to_spawn; i++)
    {
        var spawnpoint = array_pop(spawnpoints)
        instance_create_layer(spawnpoint.x, spawnpoint.y, spawnpoint.layer, object_to_spawn)
    }
}