//Generate road tiles. We can make this smarter later

enum road_tiles_e {
	ROAD_TILE_UNSET = -1, 
	ROAD_TILE_UNDEFINED_A, //none
	ROAD_TILE_NW_CORNER, //SOUTH and EAST
	ROAD_TILE_SW_CORNER, //NORTH and EAST
	ROAD_TILE_EW_ROAD, //WEST and EAST
	ROAD_TILE_UNDEFINED_B, //none
	ROAD_TILE_N_EW_T_INTERSECTION, //NORTH, EAST, WEST
	ROAD_TILE_S_EW_T_INTERSECTION, //SOUTH, EAST, WEST
	ROAD_TILE_S_CULDESAC, //NORTH
	ROAD_TILE_EW_FOUR_WAY_INTERSECTION, //NORTH, SOUTH, EAST, WEST
	ROAD_TILE_NE_CORNER, //SOUTH, WEST
	ROAD_TILE_SE_CORNER, //NORTH, WEST
	ROAD_TILE_NS_ROAD, //NORTH, SOUTH
	ROAD_TILE_W_NS_T_INTERSECTION, //NORTH, SOUTH, WEST
	ROAD_TILE_E_NS_T_INTERSECTION, //NORTH, SOUTH, EAST	
	ROAD_TILE_W_CULDESAC, //EAST
	ROAD_TILE_N_CULDESAC, //SOUTH
	ROAD_TILE_COUNT
};

enum DIR {
    NONE = 0,
    NORTH = 1,
    EAST = 2,
    SOUTH = 4,
    WEST = 8,
	INTERSECTION = 16
}

global.road_connections = array_create(road_tiles_e.ROAD_TILE_COUNT, DIR.NONE);
global.road_connections[road_tiles_e.ROAD_TILE_UNDEFINED_A]     	= DIR.NONE; //none
global.road_connections[road_tiles_e.ROAD_TILE_NW_CORNER]         	= DIR.NONE | DIR.SOUTH | DIR.EAST; //SOUTH and EAST
global.road_connections[road_tiles_e.ROAD_TILE_SW_CORNER]         	= DIR.NONE | DIR.NORTH | DIR.EAST; //NORTH and EAST
global.road_connections[road_tiles_e.ROAD_TILE_EW_ROAD]         	= DIR.NONE | DIR.EAST | DIR.WEST; //WEST and EAST
global.road_connections[road_tiles_e.ROAD_TILE_UNDEFINED_B]     	= DIR.NONE; //none
global.road_connections[road_tiles_e.ROAD_TILE_N_EW_T_INTERSECTION] = DIR.NONE | DIR.NORTH | DIR.EAST | DIR.WEST | DIR.INTERSECTION; //NORTH, EAST, WEST
global.road_connections[road_tiles_e.ROAD_TILE_S_EW_T_INTERSECTION] = DIR.NONE | DIR.SOUTH | DIR.EAST | DIR.WEST | DIR.INTERSECTION; //SOUTH, EAST, WEST
global.road_connections[road_tiles_e.ROAD_TILE_S_CULDESAC]     		= DIR.NONE | DIR.NORTH; //none
global.road_connections[road_tiles_e.ROAD_TILE_EW_FOUR_WAY_INTERSECTION] = DIR.NONE | DIR.NORTH | DIR.SOUTH | DIR.EAST | DIR.WEST | DIR.INTERSECTION; //NORTH, SOUTH, EAST, WEST
global.road_connections[road_tiles_e.ROAD_TILE_NE_CORNER]         	= DIR.NONE | DIR.SOUTH | DIR.WEST; //SOUTH, WEST
global.road_connections[road_tiles_e.ROAD_TILE_SE_CORNER]         	= DIR.NONE | DIR.NORTH | DIR.WEST; //NORTH, WEST
global.road_connections[road_tiles_e.ROAD_TILE_NS_ROAD]         	= DIR.NONE | DIR.NORTH | DIR.SOUTH; //NORTH, SOUTH
global.road_connections[road_tiles_e.ROAD_TILE_W_NS_T_INTERSECTION] = DIR.NONE | DIR.NORTH | DIR.SOUTH | DIR.WEST | DIR.INTERSECTION;//NORTH, SOUTH, WEST
global.road_connections[road_tiles_e.ROAD_TILE_E_NS_T_INTERSECTION] = DIR.NONE | DIR.NORTH | DIR.SOUTH | DIR.EAST | DIR.INTERSECTION;//NORTH, SOUTH, EAST
global.road_connections[road_tiles_e.ROAD_TILE_W_CULDESAC]     		= DIR.NONE | DIR.EAST; //none
global.road_connections[road_tiles_e.ROAD_TILE_N_CULDESAC]     		= DIR.NONE | DIR.SOUTH; //none



//Create the tile mapping. Fill center with 4-way blocks and borders with unreachable blocks
global.horizontal_tile_count = 10;
global.vertical_tile_count = 6;
global.level_data = array_create(global.vertical_tile_count);

// First row - all unreachable blocks
global.level_data[0] = array_create(global.horizontal_tile_count, road_tiles_e.ROAD_TILE_UNDEFINED_B);

// Middle rows - unreachable blocks on edges, fully-connected in the middle
for (var i = 1; i < global.vertical_tile_count - 1; i++) {
    global.level_data[i] = array_create(global.horizontal_tile_count, road_tiles_e.ROAD_TILE_UNSET);
    global.level_data[i][0] = road_tiles_e.ROAD_TILE_UNDEFINED_B;  // Left edge
    global.level_data[i][global.horizontal_tile_count - 1] = road_tiles_e.ROAD_TILE_UNDEFINED_B;  // Right edge
}

// Last row - all unreachable blocks
global.level_data[global.vertical_tile_count - 1] = array_create(global.horizontal_tile_count, road_tiles_e.ROAD_TILE_UNDEFINED_B);

// Sprinkle-in some unreachable blocks to act as city block tiles
global.unreachable_block_count = 5;
for (var i = 0; i < global.unreachable_block_count; i++) {
    var rand_y = floor(random_range(1, global.vertical_tile_count - 1));
    var rand_x = floor(random_range(1, global.horizontal_tile_count - 1));
    global.level_data[rand_y][rand_x] = road_tiles_e.ROAD_TILE_UNDEFINED_B;
}


function pick_road_tiles(x_index, y_index, arr_w, arr_l) {
    var required_dir = DIR.NONE;

    // Initialize neighbor tiles to default (no connections)
    var west_tile = road_tiles_e.ROAD_TILE_UNDEFINED_B;
    var east_tile = road_tiles_e.ROAD_TILE_UNDEFINED_B;
    var north_tile = road_tiles_e.ROAD_TILE_UNDEFINED_B;
    var south_tile = road_tiles_e.ROAD_TILE_UNDEFINED_B;
    
    // Check west neighbor
    if (x_index > 0) {
        west_tile = global.level_data[y_index][x_index - 1];
        if (west_tile == road_tiles_e.ROAD_TILE_UNSET || 
            global.road_connections[west_tile] & DIR.EAST) {
            required_dir |= DIR.WEST;
			//show_debug_message("Needs west");
        }
    }
    
    // Check east neighbor
    if (x_index < arr_w - 1) {
        east_tile = global.level_data[y_index][x_index + 1];
        if (east_tile == road_tiles_e.ROAD_TILE_UNSET || 
            global.road_connections[east_tile] & DIR.WEST) {
            required_dir |= DIR.EAST;
			//show_debug_message("Needs east");
        }
    }
    
    // Check north neighbor
    if (y_index > 0) {
        north_tile = global.level_data[y_index - 1][x_index];
        if (north_tile == road_tiles_e.ROAD_TILE_UNSET || 
            global.road_connections[north_tile] & DIR.SOUTH) {
            required_dir |= DIR.NORTH;
			//show_debug_message("Needs north");
        }
    }
    
    // Check south neighbor
    if (y_index < arr_l - 1) {
        south_tile = global.level_data[y_index + 1][x_index];
        if (south_tile == road_tiles_e.ROAD_TILE_UNSET || 
            global.road_connections[south_tile] & DIR.NORTH) {
            required_dir |= DIR.SOUTH;
			//show_debug_message("Needs south");
        }
    }

    var neighbor_intersection = false;
	if (north_tile != road_tiles_e.ROAD_TILE_UNSET && global.road_connections[north_tile] & DIR.INTERSECTION) {
		//show_debug_message("north neighbor is intersection");
		neighbor_intersection = true;
	}
	if (south_tile != road_tiles_e.ROAD_TILE_UNSET && global.road_connections[south_tile] & DIR.INTERSECTION) {
		//show_debug_message("south_tile neighbor is intersection");
		neighbor_intersection = true;
	}
	if (east_tile != road_tiles_e.ROAD_TILE_UNSET && global.road_connections[east_tile] & DIR.INTERSECTION) {
		//show_debug_message("east_tile neighbor is intersection");
		neighbor_intersection = true;
	}
	if (west_tile != road_tiles_e.ROAD_TILE_UNSET && global.road_connections[west_tile] & DIR.INTERSECTION) {
		//show_debug_message("west_tile neighbor is intersection");
		neighbor_intersection = true;
	}


	if (north_tile == road_tiles_e.ROAD_TILE_UNSET)
	{
		//show_debug_message("north_tile unset");
	}
	if (south_tile == road_tiles_e.ROAD_TILE_UNSET)
	{
		//show_debug_message("south_tile unset");
	}
	if (east_tile == road_tiles_e.ROAD_TILE_UNSET)
	{
		//show_debug_message("east_tile unset");
	}
	if (west_tile == road_tiles_e.ROAD_TILE_UNSET)
	{
		//show_debug_message("west_tile unset");
	}

    //if ((north_tile != road_tiles_e.ROAD_TILE_UNSET && global.road_connections[north_tile] & DIR.INTERSECTION) || 
    //    (south_tile != road_tiles_e.ROAD_TILE_UNSET && global.road_connections[south_tile] & DIR.INTERSECTION) || 
    //    (east_tile != road_tiles_e.ROAD_TILE_UNSET && global.road_connections[east_tile] & DIR.INTERSECTION) || 
    //    (west_tile != road_tiles_e.ROAD_TILE_UNSET && global.road_connections[west_tile] & DIR.INTERSECTION)) {
    //    neighbor_intersection = true;
    //}
    
    // Collect all valid tiles
    var valid_tiles = [];
    var dir_mask = DIR.NORTH | DIR.SOUTH | DIR.EAST | DIR.WEST;

	//show_debug_message("Required dir: " + string(required_dir));
   // show_debug_message("Neighbor intersection: " + string(neighbor_intersection));
    
    for (var i = 0; i < road_tiles_e.ROAD_TILE_COUNT; i++) {
        var tile_dirs = global.road_connections[i] & dir_mask;
        
		//show_debug_message("Tile Dirs: " + string(tile_dirs) + ", Required: " + string(required_dir) + ", is intersection " + string(global.road_connections[i] & DIR.INTERSECTION));

        // Must have all required directions
        //if ((tile_dirs & required_dir) != required_dir) continue;
        if (tile_dirs != required_dir) continue;

		// Only prevent 4-way intersections from being adjacent to any intersection
        var is_four_way = (global.road_connections[i] & dir_mask) == 15; // All 4 directions
		if (neighbor_intersection && is_four_way) continue;
        
		//show_debug_message("ADDING VALID TILE: " + string(i) + " with dirs: " + string(tile_dirs));
        array_push(valid_tiles, i);
    }

	//show_debug_message("Total valid tiles found: " + string(array_length(valid_tiles)));

    // Pick a random tile from valid options
    if (array_length(valid_tiles) > 0) {
        return valid_tiles[irandom(array_length(valid_tiles) - 1)];
    }
    
    return road_tiles_e.ROAD_TILE_UNDEFINED_B;
}

var tile_layer = layer_get_id("road_tiles_lyr");
var tilemap = layer_tilemap_get_id(tile_layer);

for (var yy = 0; yy < array_length(global.level_data); yy++) {
    for (var xx = 0; xx < array_length(global.level_data[yy]); xx++) {
        var tile_index = global.level_data[yy][xx];
		if (tile_index == road_tiles_e.ROAD_TILE_UNSET) //Skip blocked out tiles
		{
			tile_index = pick_road_tiles(xx, yy, global.horizontal_tile_count, global.vertical_tile_count);
			 global.level_data[yy][xx] = tile_index;
		}
        tilemap_set(tilemap, tile_index, xx, yy);
    }
}

/////////////////TEST//////////////////
//global.level_data = [
//	[road_tiles_e.ROAD_TILE_UNDEFINED_A, //none
//	road_tiles_e.ROAD_TILE_NW_CORNER, //SOUTH and EAST
//	road_tiles_e.ROAD_TILE_SW_CORNER, //NORTH and EAST
//	road_tiles_e.ROAD_TILE_EW_ROAD, //WEST and EAST
//	road_tiles_e.ROAD_TILE_UNDEFINED_B, //none
//	road_tiles_e.ROAD_TILE_N_EW_T_INTERSECTION, //NORTH, EAST, WEST
//	road_tiles_e.ROAD_TILE_S_EW_T_INTERSECTION, //SOUTH, EAST, WEST
//	road_tiles_e.ROAD_TILE_UNDEFINED_C], //none
//	[road_tiles_e.ROAD_TILE_EW_FOUR_WAY_INTERSECTION, //NORTH, SOUTH, EAST, WEST
//	road_tiles_e.ROAD_TILE_NE_CORNER, //SOUTH, WEST
//	road_tiles_e.ROAD_TILE_SE_CORNER, //NORTH, WEST
//	road_tiles_e.ROAD_TILE_NS_ROAD, //NORTH, SOUTH
//	road_tiles_e.ROAD_TILE_W_NS_T_INTERSECTION, //NORTH, SOUTH, WEST
//	road_tiles_e.ROAD_TILE_E_NS_T_INTERSECTION, //NORTH, SOUTH, EAST	
//	road_tiles_e.ROAD_TILE_UNDEFINED_D, //none
//	road_tiles_e.ROAD_TILE_UNDEFINED_E] //none
//];
//
//
//var tile_layer = layer_get_id("road_tiles_lyr");
//var tilemap = layer_tilemap_get_id(tile_layer);
//
//var i=0;
//for (var yy = 0; yy < array_length(global.level_data); yy++) {
//    for (var xx = 0; xx < array_length(global.level_data[yy]); xx++) {
//        tilemap_set(tilemap, global.level_data[yy][xx], xx, yy);
//    }
//}
