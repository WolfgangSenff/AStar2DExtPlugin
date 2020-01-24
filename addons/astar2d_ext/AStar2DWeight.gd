extends Node2D

const GroupName = "astar2d_ext"

var astar2d_map

export (bool) var ShouldDisableTile = false

func _ready() -> void:
    astar2d_map = get_tree().get_nodes_in_group(GroupName)[0]

func set_weight(value):
    if ShouldDisableTile:
        astar2d_map.disable_astar_node_at_position(global_position)
    else:
        astar2d_map.update_astar_weight_at_position(global_position, value)
