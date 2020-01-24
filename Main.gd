extends Node2D

onready var astar2dext = $Floor/AStar2DExt
onready var mountains = $Mountains
const mountain_randomize_iterations = 3

func _ready() -> void:
    randomize()
    astar2dext.build_astar2d_map()
    astar2dext.full_update_indicator_colors_for_weight()
    # This is just for debugging. You'd want to do this manually, for instance in the ready func of your object
#    for idx in mountain_randomize_iterations:
#        for mountain in mountains.get_children():
#            var weight_at_position = astar2dext.get_astar_weight_at_pos(mountain.global_position)
#            var weight_child = mountain.get_node("AStar2DWeight")
#            weight_child.set_weight(weight_at_position + (randi() % int(rand_range(1, 100))))
#
