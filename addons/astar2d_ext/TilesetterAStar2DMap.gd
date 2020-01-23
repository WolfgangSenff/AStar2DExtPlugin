extends AStar2DMap
class_name TilesetterAStar2DMap

export (bool) var AllowDiagonal = false

const Right = Vector2.RIGHT
const Left = Vector2.LEFT
const Up = Vector2.UP
const Down = Vector2.DOWN

var map = {
    # Vector2 -> Array<Vector2>
   }

func get_generated_map() -> Dictionary:
    # Set autotile coords as first vector, then array of connections from there
    add_connections(Vector2(0, 0), [Right, Down])
    add_conditional(Vector2(0, 0), Right + Down)
    
    add_connections(Vector2(1, 0), [Right, Left, Down])
    add_conditional(Vector2(1, 0), Right + Down)
    add_conditional(Vector2(1, 0), Left + Down)
    
    add_connections(Vector2(2, 0), [Left, Down])
    add_conditional(Vector2(2, 0), Left + Down)
    
    add_down(Vector2(3, 0))
    
    add_connections(Vector2(4, 0), [Down, Right])
    
    add_connections(Vector2(5, 0), [Down, Left, Right])
    add_conditional(Vector2(5, 0), Down + Left)
    
    add_connections(Vector2(6, 0), [Left, Down, Right])
    add_conditional(Vector2(6, 0), Down + Right)
    
    add_connections(Vector2(7, 0), [Left, Down])
    
    add_connections(Vector2(8, 0), [Left, Down, Right])
    
    add_connections(Vector2(9, 0), [Left, Right, Down, Up])
    add_conditional(Vector2(9, 0), Up + Left)    
    add_conditional(Vector2(9, 0), Down + Right)
    
    add_connections(Vector2(0, 1), [Up, Right, Down])
    add_conditional(Vector2(0, 1), Down + Right)
    add_conditional(Vector2(0, 1), Up + Right)

    add_connections(Vector2(1, 1), [Left, Right, Up, Down])
    add_conditional(Vector2(1, 1), Left + Up)    
    add_conditional(Vector2(1, 1), Right + Up)    
    add_conditional(Vector2(1, 1), Right + Down)    
    add_conditional(Vector2(1, 1), Left + Down)
    
    add_connections(Vector2(2, 1), [Up, Left, Down])
    add_conditional(Vector2(2, 1), Up + Left)
    add_conditional(Vector2(2, 1), Down + Left)
    
    add_connections(Vector2(3, 1), [Up, Down])
    
    add_connections(Vector2(4, 1), [Up, Right, Down])
    add_conditional(Vector2(4, 1), Up + Right)
    
    add_connections(Vector2(5, 1), [Left, Up, Right, Down])
    add_conditional(Vector2(5, 1), Left + Up)
    add_conditional(Vector2(5, 1), Right + Up)
    add_conditional(Vector2(5, 1), Left + Down)
    
    add_connections(Vector2(6, 1), [Left, Up, Right, Down])
    add_conditional(Vector2(6, 1), Left + Up)
    add_conditional(Vector2(6, 1), Right + Up)
    add_conditional(Vector2(6, 1), Right + Down)
    
    add_connections(Vector2(7, 1), [Left, Up, Down])
    add_conditional(Vector2(7, 1), Up + Left)
    
    add_connections(Vector2(8, 1), [Left, Up, Right, Down])
    add_conditional(Vector2(8, 1), Up + Left)
    add_conditional(Vector2(8, 1), Up + Right)
    
    add_connections(Vector2(9, 1), [Up, Right, Left, Down])
    add_conditional(Vector2(9, 1), Up + Right)
    add_conditional(Vector2(9, 1), Down + Left)
    
    add_connections(Vector2(0, 2), [Up, Right])
    add_conditional(Vector2(0, 2), Up + Right)
    
    add_connections(Vector2(1, 2), [Left, Up, Right])
    add_conditional(Vector2(1, 2), Left + Up)
    add_conditional(Vector2(1, 2), Right + Up)
    
    add_connections(Vector2(2, 2), [Left, Up])
    add_conditional(Vector2(2, 2), Left + Up)
    
    add_connections(Vector2(3, 2), [Up])
    
    add_connections(Vector2(4, 2), [Up, Right, Down])
    add_conditional(Vector2(4, 2), Down + Right)
    
    add_connections(Vector2(5, 2), [Up, Left, Down, Right])
    add_conditional(Vector2(5, 2), Up + Left)
    add_conditional(Vector2(5, 2), Down + Left)
    add_conditional(Vector2(5, 2), Down + Right)
    
    add_connections(Vector2(6, 2), [Up, Right, Down, Left])
    add_conditional(Vector2(6, 2), Up + Right)
    add_conditional(Vector2(6, 2), Down + Right)
    add_conditional(Vector2(6, 2), Down + Left)
    
    add_connections(Vector2(7, 2), [Up, Left, Down])
    add_conditional(Vector2(7, 2), Down + Left)
    
    add_connections(Vector2(8, 2), [Up, Right, Down, Left])
    add_conditional(Vector2(8, 2), Down + Left)
    add_conditional(Vector2(8, 2), Down + Right)
    
    add_connections(Vector2(9, 2), [Up, Left, Right, Down])
    add_conditional(Vector2(9, 2), Right + Down)
    
    add_connections(Vector2(10, 2), [Up, Left, Right, Down])
    add_conditional(Vector2(10, 2), Left + Down)
    
    add_connections(Vector2(0, 3), [Right])

    add_connections(Vector2(1, 3), [Left, Right])
    
    add_connections(Vector2(2, 3), [Left])
    
    add_connections(Vector2(3, 3), [])
    
    add_connections(Vector2(4, 3), [Up, Right])
    
    add_connections(Vector2(5, 3), [Left, Up, Right])
    add_conditional(Vector2(5, 3), Left + Up)
    
    add_connections(Vector2(6, 3), [Left, Up, Right])
    add_conditional(Vector2(6, 3), Right + Up)
    
    add_connections(Vector2(7, 3), [Up, Left])
    
    add_connections(Vector2(8, 3), [Left, Up, Right])
    
    add_connections(Vector2(9, 3), [Left, Up, Right, Down])
    add_conditional(Vector2(9, 3), Up + Right)
    
    add_connections(Vector2(10, 3), [Left, Up, Right, Down])
    add_conditional(Vector2(10, 3), Up + Left)
 
    add_connections(Vector2(4, 4), [Up, Right, Down])
    
    add_connections(Vector2(5, 4), [Right, Left, Up, Down])
    add_conditional(Vector2(5, 4), Left + Up)
    add_conditional(Vector2(5, 4), Left + Down)
    
    add_connections(Vector2(6, 4), [Right, Left, Up, Down])
    add_conditional(Vector2(6, 4), Right + Up)
    add_conditional(Vector2(6, 4), Right + Down)
    
    add_connections(Vector2(7, 4), [Up, Left, Down])
    
    add_connections(Vector2(8, 4), [Up, Left, Right, Down])
    return map

func add_connections(cellv : Vector2, directions : Array) -> void:
    for direction in directions:
        add_connection(cellv, direction)
        
func add_conditional(cellv : Vector2, direction : Vector2) -> void:
    if AllowDiagonal:
        add_connection(cellv, direction)

func add_right(cellv : Vector2) -> void:
    add_connection(cellv, Right)

func add_left(cellv : Vector2) -> void:
    add_connection(cellv, Left)

func add_up(cellv : Vector2) -> void:
    add_connection(cellv, Up)

func add_down(cellv : Vector2) -> void:
    add_connection(cellv, Down)

func add_connection(cellv : Vector2, direction : Vector2) -> void:
    if !map.has(cellv):
        map[cellv] = []
        
    if map[cellv].find(direction) == -1:
        map[cellv].push_back(direction)
        
