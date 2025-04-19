extends Sprite2D

@export var rotation_speed: float = 10.0
var previous_mouse_pos: Vector2

func _ready() -> void:
    previous_mouse_pos = get_viewport().get_mouse_position()

func _process(delta: float) -> void:
    var current_mouse_pos: Vector2 = get_viewport().get_mouse_position()
    global_position = current_mouse_pos

    var movement: Vector2 = current_mouse_pos - previous_mouse_pos
    var move_distance: float = movement.length()
    rotation += rotation_speed * move_distance * delta

    previous_mouse_pos = current_mouse_pos
