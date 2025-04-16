extends Control
@onready var dropdown_container = $ModelSelector
@onready var dropdown = $ModelSelector/ModelDropdown
var current_model = ""

func _ready():
	# Create and set up the model selection dropdown
	create_model_dropdown()
	
	# Update the task buttons based on the selected model
	update_task_buttons()

# Function to create and set up the model selection dropdown
func create_model_dropdown():
	dropdown.unique_name_in_owner = true
	var control_node = get_node("Control")
	
	# Create a VBoxContainer to hold both the existing label and the dropdown
	var vbox = VBoxContainer.new()
	vbox.name = "VBoxContainer"
	
	# Move the existing label to the VBox
	var existing_label = control_node.get_node("Label")
	if existing_label:
		control_node.remove_child(existing_label)
		vbox.add_child(existing_label)
	
	# Add the dropdown container to the VBox
	vbox.add_child(dropdown_container)
	
	# Add the VBox to the control node
	control_node.add_child(vbox)
	
	# Get all model folders
	var dir = DirAccess.open("res://Tasks")
	dropdown.remove_item(0)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if dir.current_is_dir() and file_name != "." and file_name != "..":
				# Add the model to the dropdown, replacing underscores with spaces
				var display_name = file_name.replace("_", " ")
				dropdown.add_item(display_name)
				
				# Store the original folder name as metadata
				var idx = dropdown.get_item_count() - 1
				dropdown.set_item_metadata(idx, file_name)
			
			file_name = dir.get_next()
	
	# Connect the dropdown signal
	dropdown.item_selected.connect(_on_model_selected)
	
	# Select the first model by default
	if dropdown.get_item_count() > 0:
		dropdown.select(0)
		current_model = dropdown.get_item_metadata(0)

	call_deferred("_on_model_selected", 0)

# Function to handle model selection
func _on_model_selected(index):
	current_model = dropdown.get_item_metadata(index)
	var tasks = []
	var dir = DirAccess.open("res://Tasks/" + current_model)
	if dir:
		dir.list_dir_begin()
		var file_name: String = dir.get_next()
		if file_name.begins_with("Task"):
			while file_name != "":
				if dir.current_is_dir() and file_name != "." and file_name != "..":
					# Add the task to the list
					tasks.append(int(file_name.replace("Task ", "").replace("_", "")))
				file_name = dir.get_next()
		
	update_task_buttons(tasks)

# Function to update the task buttons based on the selected model
func update_task_buttons(tasks: Array = []):
	var buttons = %Buttons
	
	# Clear existing buttons
	for child in buttons.get_children():
		buttons.remove_child(child)
		child.queue_free()
	
	# Create buttons for all Task folders
	for i in tasks: # Tasks 1-9
		var task_button = Button.new()
		task_button.text = "Task " + str(i)
		task_button.add_theme_font_size_override("font_size", 36)
		
		# Connect the button to a function that will change the scene
		task_button.pressed.connect(_on_task_button_pressed.bind(i))
		
		# Add the button to the container
		buttons.add_child(task_button)

# Function to handle button press and change scene
func _on_task_button_pressed(task_number):
	var scene_path = "res://Tasks/" + current_model + "/Task " + str(task_number) + "/task_" + str(task_number) + ".tscn"
	
	# Check if the scene exists
	if ResourceLoader.exists(scene_path):
		# Change to the task scene
		get_tree().change_scene_to_file(scene_path)
	else:
		# Scene doesn't exist, show an error
		push_error("Scene not found: " + scene_path)
