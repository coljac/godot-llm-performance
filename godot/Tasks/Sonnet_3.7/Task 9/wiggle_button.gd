extends Button
class_name WiggleButton

# Export variables to make wiggle configurable
@export var wiggle_amount: float = 5.0:
	set = _set_wiggle_amount
@export var wiggle_speed: float = 10.0:
	set = _set_wiggle_speed

# Internal variables for wiggle effect
var _is_wiggling: bool = false
var _time: float = 0.0
var _original_position: Vector2
var _rng = RandomNumberGenerator.new()

func _ready():
	# Store the original position for reference
	_original_position = position
	# Connect mouse signals
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	print("Position-based WiggleButton initialized with:")
	print("- Wiggle Amount: ", wiggle_amount)
	print("- Wiggle Speed: ", wiggle_speed)

func _process(delta):
	if _is_wiggling:
		# Increment time for the wiggle effect
		_time += delta * wiggle_speed
		
		# Calculate wiggle offset using sine waves with some randomness
		var offset_x = sin(_time * 1.5) * wiggle_amount * _rng.randf_range(0.8, 1.2)
		var offset_y = cos(_time * 2.0) * wiggle_amount * _rng.randf_range(0.8, 1.2)
		
		# Apply the wiggle offset to the position
		position = _original_position + Vector2(offset_x, offset_y)

# Validate and clamp export variables when they change
func _set_wiggle_amount(value):
	wiggle_amount = clamp(value, 0.0, 50.0)
	
func _set_wiggle_speed(value):
	wiggle_speed = clamp(value, 0.1, 30.0)

# Public method to manually trigger wiggle effect
func trigger_wiggle(duration: float = 1.0):
	_is_wiggling = true
	_time = 0.0
	_rng.randomize()
	
	# Create a timer to stop wiggling after the specified duration
	var timer = get_tree().create_timer(duration)
	timer.timeout.connect(_on_wiggle_timer_timeout)

# Called when the wiggle timer times out
func _on_wiggle_timer_timeout():
	_is_wiggling = false
	position = _original_position

func _on_mouse_entered():
	# Start wiggling when mouse enters
	_is_wiggling = true
	_time = 0.0
	_rng.randomize()

func _on_mouse_exited():
	# Stop wiggling when mouse exits
	_is_wiggling = false
	# Reset position to original
	position = _original_position