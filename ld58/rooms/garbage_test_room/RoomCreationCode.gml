//Generate road tiles
var level_data = [
    [1, 1, 1, 1, 1],
    [1, 0, 0, 0, 1],
    [1, 0, 2, 0, 1],
    [1, 0, 0, 0, 1],
    [1, 1, 1, 1, 1]
];

var tile_layer = layer_get_id("road_tiles_lyr");
var tilemap = layer_tilemap_get_id("city_street_tiles");

for (var yy = 0; yy < array_length(level_data); yy++) {
    for (var xx = 0; xx < array_length(level_data[yy]); xx++) {
        var tile_index = level_data[yy][xx];
        if (tile_index > 0) {
            tilemap_set(tilemap, tile_index, xx, yy);
        }
    }
}