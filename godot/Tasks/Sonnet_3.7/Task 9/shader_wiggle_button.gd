extends Button
class_name ShaderWiggleButton

# Export variables to make wiggle configurable
@export var wiggle_amount: float = 5.0:
	set = _set_wiggle_amount
@export var wiggle_speed: float = 10.0:
	set = _set_wiggle_speed

# Internal variables
var _shader_material: ShaderMaterial

func _ready():
	# Create shader material and apply it to the button
	_shader_material = ShaderMaterial.new()
	_shader_material.shader = load("res://Tasks/Sonnet_3.7/Task 9/wiggle_shader.gdshader")
	
	# Set initial shader parameters
	_shader_material.set_shader_parameter("wiggle_amount", wiggle_amount)
	_shader_material.set_shader_parameter("wiggle_speed", wiggle_speed)
	_shader_material.set_shader_parameter("is_wiggling", false)
	
	# Apply the material to the button
	material = _shader_material
	
	# Connect mouse signals
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	print("Shader-based WiggleButton initialized with:")
	print("- Wiggle Amount: ", wiggle_amount)
	print("- Wiggle Speed: ", wiggle_speed)

func _on_mouse_entered():
	# Start wiggling when mouse enters
	_shader_material.set_shader_parameter("is_wiggling", true)

func _on_mouse_exited():
	# Stop wiggling when mouse exits
	_shader_material.set_shader_parameter("is_wiggling", false)

# Update shader parameters if wiggle properties change
func _process(_delta):
	if _shader_material:
		if _shader_material.get_shader_parameter("wiggle_amount") != wiggle_amount:
			_shader_material.set_shader_parameter("wiggle_amount", wiggle_amount)
		
		if _shader_material.get_shader_parameter("wiggle_speed") != wiggle_speed:
			_shader_material.set_shader_parameter("wiggle_speed", wiggle_speed)

# Validate and clamp export variables when they change
func _set_wiggle_amount(value):
	wiggle_amount = clamp(value, 0.0, 50.0)
	if _shader_material:
		_shader_material.set_shader_parameter("wiggle_amount", wiggle_amount)
	
func _set_wiggle_speed(value):
	wiggle_speed = clamp(value, 0.1, 30.0)
	if _shader_material:
		_shader_material.set_shader_parameter("wiggle_speed", wiggle_speed)

# Error handling for shader loading
func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		# Clean up resources when the node is about to be deleted
		_shader_material = null

# Public method to manually trigger wiggle effect
func trigger_wiggle(duration: float = 1.0):
	if _shader_material:
		_shader_material.set_shader_parameter("is_wiggling", true)
		
		# Create a timer to stop wiggling after the specified duration
		var timer = get_tree().create_timer(duration)
		timer.timeout.connect(_on_wiggle_timer_timeout)

# Called when the wiggle timer times out
func _on_wiggle_timer_timeout():
	if _shader_material:
		_shader_material.set_shader_parameter("is_wiggling", false)