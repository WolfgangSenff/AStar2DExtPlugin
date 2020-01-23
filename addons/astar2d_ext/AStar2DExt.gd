extends Node2D
class_name AStar2DExt

signal astar_map_updated(cell) # Try to decide anything else useful that might go here
signal astar_map_got_random_position(pos) # Ugh

export (Resource) var AStar2DMapResource
export (Vector2) var IndicatorScale = Vector2(1, 1)
export (bool) var ShowIndicators
export (Gradient) var IndicatorColorGradient
export (float) var MaxWeight
export (bool) var IsAutotile
export (int) var IndicatorZIndex = 1

var current_time = 0.0

var tilemap : TileMap
var astar2d_map = AStar2D.new()

var cell_to_indicators_map = {}
var id_to_cell_map = {}
var cell_to_id_map = {}

const visual_indicator_scene = preload("res://addons/astar2d_ext/AStar2DVisualIndicator.tscn")

func _ready() -> void:
    tilemap = get_parent()
    add_to_group("astar2d_ext")

func print_tilemap_autotile_coords() -> void:
    if IsAutotile:
        var used_cells = tilemap.get_used_cells()
        for cell in used_cells:
            var cell_autotile_coord = tilemap.get_cell_autotile_coord(cell.x, cell.y)
            print("Cell at: " + str(cell) + " has autotile coord: " + str(cell_autotile_coord))

func print_tilemap() -> void:
    var used_cells = tilemap.get_used_cells()
    for cell in used_cells:
        var cell_value = tilemap.get_cellv(cell)
        print("Cell at: " + str(cell) + " is value: " + str(cell_value))

func get_random_astar_pos(in_world_coordinates : bool):
    var keys = cell_to_id_map.keys()
    var random_id = keys[randi() % keys.size()]
    var world_coords = tilemap.map_to_world(random_id)
    if in_world_coordinates:
        random_id = world_coords
    
    return random_id

func get_astar_path_to_pos(from_pos : Vector2, to_pos : Vector2) -> PoolVector2Array:
    var from_cell = tilemap.world_to_map(from_pos)
    var from_id = get_cell_id_at_pos(from_cell)
    # Remember, get_cell_id_at_pos assumes Vector2.ZERO if position isn't presesnt in the map
    var to_cell = tilemap.world_to_map(to_pos)
    var to_id = get_cell_id_at_pos(to_cell)
    if from_id is int and from_id != -1:
        return astar2d_map.get_point_path(from_id, to_id)
        
    return PoolVector2Array()

func get_point_position(cell : Vector2) -> Vector2:
    return tilemap.map_to_world(cell)

func add_base_values(used_cells):
    for cell in used_cells:
        var next_id = astar2d_map.get_available_point_id()
        astar2d_map.add_point(next_id, cell, 1)
        id_to_cell_map[next_id] = cell # Save these for later; there used to be a good reason, though can't think of it off the top of my brain right now
        cell_to_id_map[cell] = next_id

func update_astar_weight_at_position(pos, weight):
    var cell = tilemap.world_to_map(pos)
    update_astar_weight_at(cell, weight)
    emit_signal("astar_map_updated", cell)

func get_astar_weight_at_pos(pos):
    var cell = tilemap.world_to_map(pos)
    var cell_id = get_cell_id_at_pos(cell)
    return astar2d_map.get_point_weight_scale(cell_id)
    
func disable_astar_node_at_position(pos):
    var cell = tilemap.world_to_map(pos)
    var cell_id = get_cell_id_at_pos(cell)
    if cell_id != -1:
        astar2d_map.set_point_disabled(cell_id, true)
        emit_signal("astar_map_updated", cell)

func enable_astar_node_at_position(pos):
    var cell = tilemap.world_to_map(pos)
    var cell_id = get_cell_id_at_pos(cell)
    if cell_id != -1:
        astar2d_map.set_point_disabled(cell_id, false)
        emit_signal("astar_map_updated", cell)

func get_cell_id_at_pos(cell : Vector2):
    if cell_to_id_map.has(cell):
        return cell_to_id_map[cell]
        
    print("Cell to id map does not have: " + str(cell))
    return -1

func update_astar_weight_at(cell : Vector2, weight : float):
    var cell_id = cell_to_id_map[cell]
    astar2d_map.set_point_weight_scale(cell_id, weight)
    if ShowIndicators:
        var possible_connections = [Vector2.LEFT, Vector2.LEFT + Vector2.UP, Vector2.UP, Vector2.UP + Vector2.RIGHT, Vector2.RIGHT, Vector2.RIGHT + Vector2.DOWN, Vector2.DOWN, Vector2.LEFT + Vector2.DOWN]
        
        # If the map has a cell with indicators
        # Go around that cell looking for connected cells
        # If they're connected, find the -direction indicator
        # set its color to the appropriate weight
        
        for connection in possible_connections:
            var connected_cell = connection + cell
            if cell_to_id_map.has(connected_cell):
                var connected_id = cell_to_id_map[connected_cell]
                if astar2d_map.are_points_connected(connected_id, cell_id):
                    var opposite_connection = -connection
                    var connected_contained = cell_to_indicators_map.has(connected_cell)
                    if cell_to_indicators_map.has(connected_cell):
                        var opposite_connected_cell = cell_to_indicators_map[connected_cell]
                        cell_to_indicators_map[connected_cell][opposite_connection].modulate = get_interpolated_color(weight)
    
    emit_signal("astar_map_updated", cell)

func build_astar2d_map() -> void:    
    var mappings = AStar2DMapResource.get_generated_map()
    # initialize all used cells to a default weight initially
    var used_cells = tilemap.get_used_cells()
    add_base_values(used_cells)
    # This is done in this painfully ugly way because for some reason, exported property inheritance wasn't working for me
    if IsAutotile:
        build_astar2d_map_autotile(used_cells, mappings)
    else:
        build_astar2d_map_manual(used_cells, mappings)

func build_astar2d_map_manual(used_cells, mappings):
    pass
    
func build_astar2d_map_autotile(used_cells, mappings):
    # go through all cells and connect according to the mappings, assuming autotile
    for cell in used_cells:
        var autotile_id = tilemap.get_cell_autotile_coord(cell.x, cell.y)
        
        if mappings.has(autotile_id):
            var connected_directions = mappings[autotile_id]
            for direction in connected_directions:
                var cell_in_direction = cell + direction
                if cell_to_id_map.has(cell_in_direction):
                    astar2d_map.connect_points(cell_to_id_map[cell], cell_to_id_map[cell_in_direction], false) # Set to false because this will go through them all anyway, effectively doing bidirectional manually
                    if ShowIndicators:
                        var indicator = visual_indicator_scene.instance()
                        add_child(indicator)
                        indicator.look_at(direction)
                        indicator.global_position = tilemap.map_to_world(cell) + (tilemap.cell_size / 2.0)
                        indicator.scale = IndicatorScale
                        indicator.z_index = IndicatorZIndex
                        if not cell_to_indicators_map.has(cell):
                            cell_to_indicators_map[cell] = {}
                            
                        cell_to_indicators_map[cell][direction] = indicator

    
func full_update_indicator_colors_for_weight() -> void:
    for cell in cell_to_indicators_map.keys():
        var indicator_list = cell_to_indicators_map[cell]
        var cell_id = cell_to_id_map[cell]
        var weight = astar2d_map.get_point_weight_scale(cell_id)
        if IndicatorColorGradient:
            var color = get_interpolated_color(weight)
            for indicator in indicator_list:
                indicator_list[indicator].modulate = color

func get_interpolated_color(weight):
    var interpolated_weight = weight / MaxWeight
    return IndicatorColorGradient.interpolate(interpolated_weight)
