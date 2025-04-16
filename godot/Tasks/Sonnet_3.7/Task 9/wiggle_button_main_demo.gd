extends Control

# Verify that all required scripts and resources are loaded correctly
func _ready():
	# Set window title
	get_window().title = "WiggleButton Demo"
	
	# Verify that all required scripts are loaded
	var position_script = load("res://Tasks/Sonnet_3.7/Task 9/wiggle_button.gd")
	var shader_script = load("res://Tasks/Sonnet_3.7/Task 9/shader_wiggle_button.gd")
	var shader_resource = load("res://Tasks/Sonnet_3.7/Task 9/wiggle_shader.gdshader")
	
	# Log verification results
	print("WiggleButton Demo Started")
	print("- Tab 1: Position-based WiggleButton")
	print("- Tab 2: Shader-based WiggleButton")
	print("- Tab 3: Programmatic WiggleButton Demo")
	
	# Verify resources
	print("\nResource Verification:")
	print("- Position-based WiggleButton script: ", "OK" if position_script else "FAILED")
	print("- Shader-based WiggleButton script: ", "OK" if shader_script else "FAILED")
	print("- Wiggle shader: ", "OK" if shader_resource else "FAILED")
	
	if position_script and shader_script and shader_resource:
		print("\nAll resources loaded successfully. The WiggleButton demo is ready!")
	else:
		push_error("Some resources failed to load. Check the console for details.")