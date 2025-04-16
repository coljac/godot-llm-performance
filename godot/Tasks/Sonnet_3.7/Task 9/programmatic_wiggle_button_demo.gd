extends Control

# This script demonstrates how to create and configure WiggleButtons programmatically

func _ready():
	# Set window title
	get_window().title = "Programmatic WiggleButton Demo"
	
	# Create a container to hold our buttons
	var container = VBoxContainer.new()
	container.alignment = BoxContainer.ALIGNMENT_CENTER
	container.set_anchors_preset(Control.PRESET_CENTER)
	container.custom_minimum_size = Vector2(400, 300)
	container.add_theme_constant_override("separation", 20)
	add_child(container)
	
	# Add a title label
	var title = Label.new()
	title.text = "Programmatic WiggleButton Demo"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 24)
	container.add_child(title)
	
	# Add an instruction label
	var instruction = Label.new()
	instruction.text = "These buttons were created programmatically"
	instruction.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	container.add_child(instruction)
	
	# Add a separator
	var separator = HSeparator.new()
	container.add_child(separator)
	
	# Create position-based WiggleButton
	var position_button = Button.new()
	position_button.text = "Position-based WiggleButton"
	position_button.custom_minimum_size = Vector2(250, 50)
	position_button.set_script(load("res://Tasks/Sonnet_3.7/Task 9/wiggle_button.gd"))
	position_button.wiggle_amount = 7.0
	position_button.wiggle_speed = 12.0
	
	# Create a label for the position-based button
	var position_label = Label.new()
	position_label.text = "Created with wiggle_button.gd"
	
	# Create a container for the button and label
	var position_container = HBoxContainer.new()
	position_container.alignment = BoxContainer.ALIGNMENT_CENTER
	position_container.add_theme_constant_override("separation", 20)
	position_container.add_child(position_button)
	position_container.add_child(position_label)
	container.add_child(position_container)
	
	# Create shader-based WiggleButton
	var shader_button = Button.new()
	shader_button.text = "Shader-based WiggleButton"
	shader_button.custom_minimum_size = Vector2(250, 50)
	shader_button.set_script(load("res://Tasks/Sonnet_3.7/Task 9/shader_wiggle_button.gd"))
	shader_button.wiggle_amount = 7.0
	shader_button.wiggle_speed = 12.0
	
	# Create a label for the shader-based button
	var shader_label = Label.new()
	shader_label.text = "Created with shader_wiggle_button.gd"
	
	# Create a container for the button and label
	var shader_container = HBoxContainer.new()
	shader_container.alignment = BoxContainer.ALIGNMENT_CENTER
	shader_container.add_theme_constant_override("separation", 20)
	shader_container.add_child(shader_button)
	shader_container.add_child(shader_label)
	container.add_child(shader_container)
	
	# Add a button to trigger the wiggle effect
	var trigger_button = Button.new()
	trigger_button.text = "Trigger Wiggle Effect (2 seconds)"
	trigger_button.custom_minimum_size = Vector2(300, 50)
	container.add_child(trigger_button)
	
	# Connect the trigger button to trigger both wiggle buttons
	trigger_button.pressed.connect(func():
		position_button.trigger_wiggle(2.0)
		shader_button.trigger_wiggle(2.0)
		print("Manually triggered wiggle effect for 2 seconds")
	)
	
	print("Programmatic WiggleButton Demo Started")
	print("- Created position-based WiggleButton with wiggle_amount=7.0, wiggle_speed=12.0")
	print("- Created shader-based WiggleButton with wiggle_amount=7.0, wiggle_speed=12.0")
	print("- Added button to manually trigger wiggle effect")
