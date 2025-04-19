extends Sprite2D

@export var rotation_speed_factor: float = 0.1

var previous_mouse_position: Vector2 = Vector2.ZERO
var mouse_velocity: Vector2 = Vector2.ZERO

func _ready():
    previous_mouse_position = get_viewport().get_mouse_position()

func _process(delta):
    # Get current mouse position
    var current_mouse_position = get_viewport().get_mouse_position()
    
    # Update sprite position to follow mouse
    position = current_mouse_position
    
    # Calculate mouse velocity
    mouse_velocity = (current_mouse_position - previous_mouse_position) / delta
    
    # Rotate sprite based on mouse velocity magnitude
    var rotation_amount = mouse_velocity.length() * 0.05 * rotation_speed_factor * delta
    rotate(rotation_amount)
    
    # Store current position for next frame
    previous_mouse_position = current_mouse_position