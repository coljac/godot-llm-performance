# sprite_mouse_follower.gd
extends Sprite2D

@export var rotation_speed_factor: float = 0.01

var previous_mouse_position: Vector2 = Vector2.ZERO

func _ready():
	# Initialize previous position to avoid large jump on first frame
	previous_mouse_position = get_global_mouse_position()

func _process(delta):
	var current_mouse_position = get_global_mouse_position()
	global_position = current_mouse_position

	var mouse_velocity = (current_mouse_position - previous_mouse_position) / delta
	var speed = mouse_velocity.length()

	rotate(speed * rotation_speed_factor * delta)

	previous_mouse_position = current_mouse_position

