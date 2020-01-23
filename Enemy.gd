extends Node2D

const GroupName = "astar2d_ext"
const Epsilon = 1.5 # square distance before we decide to stop moving
const TimeBetweenMoves = 1.0 # seconds between one movement and the next

export (float) var Speed
var current_target = Vector2.INF
var current_direction = Vector2.ZERO
var current_path = []
var current_time = 0.0

var astar2d_map
onready var astar2d_character = $AStar2DCharacter

# You can handle this however you want. This was my approach for movement
# through the graph. Another example would be to use Tweens to move
# between individual positions; it looks a bit jerky to me, so I went
# with this

func _ready() -> void:
    astar2d_map = get_tree().get_nodes_in_group(GroupName)[0]

func _physics_process(delta: float) -> void:
    if current_target == Vector2.INF or current_target.distance_squared_to(Vector2.INF) < Epsilon:
        current_time += delta
        if current_time >= TimeBetweenMoves:
            current_time = 0.0
            var result = get_random_astar_pos()
            current_path = astar2d_character.get_astar_path_to_pos(result)
            get_next_target()
            if current_target == Vector2.INF:
                return
                
            current_direction = (current_target - global_position).normalized()
    else: # navigate to the current target
        if global_position.distance_squared_to(current_target) > Epsilon:
            global_position += Speed * delta * current_direction
        else:
            get_next_target()
            if current_target != Vector2.INF:
                current_direction = (current_target - global_position).normalized()
            else:
                current_direction = Vector2.ZERO

func get_next_target() -> Vector2:
    if current_path.size() > 0:
        astar2d_map.enable_astar_node_at_position(global_position)
        var front = current_path[0]
        current_path.remove(0)
        current_target = astar2d_map.get_point_position(front)
        astar2d_map.disable_astar_node_at_position(current_target)
    else:
        # Ugly scenario, but unlikely to have any infinite maps ;)
        current_target = Vector2.INF

    return current_target

# This is more or less just for debugging/demo purposes
func get_random_astar_pos() -> Vector2:
    return astar2d_map.get_random_astar_pos(true)
