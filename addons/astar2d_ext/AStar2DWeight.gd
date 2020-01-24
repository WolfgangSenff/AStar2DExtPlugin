extends Node2D

const GroupName = "astar2d_ext"

var astar2d_map

export (bool) onready var ShouldDisableTile = false
export (float) onready var Weight

func _ready() -> void:
    astar2d_map = get_tree().get_nodes_in_group(GroupName)[0]
    call_deferred("set_weight")

func set_weight(value = null):
    if ShouldDisableTile:
        astar2d_map.disable_astar_node_at_position(global_position)
    else:
        if value:
            astar2d_map.update_astar_weight_at_position(global_position, value)
        else:
            astar2d_map.update_astar_weight_at_position(global_position, Weight)
