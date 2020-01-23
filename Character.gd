extends KinematicBody2D

const Speed = 120

func _physics_process(delta: float) -> void:
    var direction = Vector2.ZERO
    if Input.is_action_pressed("ui_left"):
        direction += Vector2.LEFT
    if Input.is_action_pressed("ui_right"):
        direction += Vector2.RIGHT
    if Input.is_action_pressed("ui_up"):
        direction += Vector2.UP
    if Input.is_action_pressed("ui_down"):
        direction += Vector2.DOWN
        
    move_and_slide(direction * Speed)
