@tool
extends Button

## The maximum distance the button will move from its original position when wiggling.
@export var wiggle_amount: float = 5.0
## How fast the button wiggles. Higher values mean faster shaking.
@export var wiggle_speed: float = 30.0

var _is_hovering: bool = false
var _time: float = 0.0
var _original_position: Vector2
var _initial_position_set: bool = false

func _ready():
	# Connect signals regardless of editor hint, but logic inside handlers might differ
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	# Ensure _process runs even when paused if needed, but usually not necessary for UI
	# process_mode = Node.PROCESS_MODE_ALWAYS

	# Defer setting original position until the first process frame or enter_tree
	# to allow layout containers to settle.
	call_deferred("_set_initial_position")


func _set_initial_position():
	if not _initial_position_set:
		_original_position = position
		_initial_position_set = true


func _process(delta):
	# Ensure original position is captured before processing wiggle
	if not _initial_position_set:
		# This might happen if call_deferred hasn't run yet
		_set_initial_position()
		# If still not set (e.g., node not in tree yet), skip processing
		if not _initial_position_set:
			return

	# Wiggle logic should only run during gameplay, not in the editor preview
	if Engine.is_editor_hint():
		# Ensure the button stays at its layout position in the editor
		if position != _original_position and _initial_position_set:
			position = _original_position
		return

	if _is_hovering:
		_time += delta * wiggle_speed
		# Using different prime multipliers for frequencies can look more random
		var offset_x = sin(_time * 1.1) * wiggle_amount
		var offset_y = cos(_time * 1.7) * wiggle_amount
		position = _original_position + Vector2(offset_x, offset_y)
	else:
		# If not hovering and not in original position, snap back.
		if position != _original_position:
			position = _original_position
			_time = 0.0 # Reset time


func _on_mouse_entered():
	# Ensure original position is set before starting hover effect
	if not _initial_position_set:
		_set_initial_position()

	_is_hovering = true
	_time = randf() * 10.0 # Start at a random time offset for less uniformity


func _on_mouse_exited():
	_is_hovering = false
	# Reset position immediately when mouse leaves if the original position is known
	if _initial_position_set and not Engine.is_editor_hint():
		position = _original_position