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

func disable_astar_position(pos):
    var tree = get_tree()
    if tree:
        previous_weight = astar2d_map.get_astar_weight_at_pos(pos)
        
        if CanBePassedThrough:
            astar2d_map.update_astar_weight_at_position(pos, Weight)
        else:
            astar2d_map.disable_astar_node_at_position(pos)
        
func restore_astar_position(pos):
    var tree = get_tree()
    if tree:
        if CanBePassedThrough and previous_weight:
            astar2d_map.update_astar_weight_at_position(pos, previous_weight)
        else:
            astar2d_map.enable_astar_node_at_position(pos)
            
        previous_weight = null
