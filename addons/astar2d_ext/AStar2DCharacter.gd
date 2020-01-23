extends Node2D

# The weird if tree calls are because I was experiencing
# an oddball effect where the tree wouldn't exist when
# calling into a property setter the first time. I don't
# necessarily think it's a bug in Godot, so haven't reported it,
# but did decide to work around it, since this is a library,
# and libraries need to be toit.
export (bool) var CanBePassedThrough
export (float) var Weight
var previous_weight
var astar2d_map

const GroupName = "astar2d_ext"

func _ready():
    astar2d_map = get_tree().get_nodes_in_group(GroupName)[0]

func disable_astar_position():
    var tree = get_tree()
    if tree:
        previous_weight = tree.call_group(GroupName, "get_astar_weight_at_pos", global_position)
        
        if CanBePassedThrough:
            tree.call_group(GroupName, "update_astar_weight_at_position", global_position, Weight)
        else:
            tree.call_group(GroupName, "disable_astar_node_at_position", global_position)
            
func restore_astar_position():
    var tree = get_tree()
    if tree:
        if CanBePassedThrough and previous_weight:
            tree.call_group(GroupName, "update_astar_weight_at_position", global_position, previous_weight)
        else:
            tree.call_group(GroupName, "enable_astar_node_at_position", global_position)
            
        previous_weight = null

func get_astar_path_to_pos(pos : Vector2) -> PoolVector2Array:
    # Get position path through graph to be able to navigate through it
    var result = astar2d_map.get_astar_path_to_pos(global_position + (astar2d_map.tilemap.cell_size / 2.0), pos)
    return result
