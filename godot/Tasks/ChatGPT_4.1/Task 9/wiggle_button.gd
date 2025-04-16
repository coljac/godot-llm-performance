extends Button

@export var wiggle_amount: float = 10.0 # Maximum pixels to wiggle
@export var wiggle_speed: float = 20.0 # How fast the wiggle oscillates

var _wiggle_time: float = 0.0
var _wiggling: bool = false
var _original_position: Vector2

func _ready():
	_original_position = position

func _process(delta):
	if _wiggling:
		_wiggle_time += delta * wiggle_speed
		var offset_x = sin(_wiggle_time * 2.0) * wiggle_amount
		var offset_y = cos(_wiggle_time * 3.0) * wiggle_amount * 0.5
		position = _original_position + Vector2(offset_x, offset_y)
	else:
		position = _original_position

func _on_mouse_entered():
	_wiggling = true

func _on_mouse_exited():
	_wiggling = false
	position = _original_position

func _enter_tree():
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))