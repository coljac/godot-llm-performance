extends Node3D

# Force multiplier for pushing cubes
@export var push_force: float = 5.0

# Currently selected cube
var selected_cube: RigidBody3D = null

# Camera reference
var camera: Camera3D

# Mouse position when dragging started
var drag_start_position: Vector2 = Vector2.ZERO

func _ready():
	# Get the camera reference
	camera = get_viewport().get_camera_3d()

func _input(event):
	# Reset scene when R is pressed
	if event is InputEventKey and event.pressed and event.keycode == KEY_R:
		get_tree().reload_current_scene()
		return
	
	# Handle mouse events
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Start dragging - try to select a cube
				_select_cube_at_mouse_position(event.position)
				drag_start_position = event.position
			else:
				# End dragging - apply force to selected cube
				if selected_cube:
					var drag_end_position = event.position
					var drag_vector = drag_end_position - drag_start_position
					
					# Apply force in the direction of the drag
					_apply_force_to_cube(drag_vector)
					
					# Clear selection
					selected_cube = null

func _select_cube_at_mouse_position(mouse_pos: Vector2):
	# Create a ray from the camera through the mouse position
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * 100
	
	# Set up physics query
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	
	# Perform the raycast
	var result = space_state.intersect_ray(query)
	
	# Check if we hit a disappearing cube
	if result and result.collider is RigidBody3D and result.collider.get_script() == load("res://Tasks/Sonnet_3.7/Task 6/disappearing_cube.gd"):
		selected_cube = result.collider

func _apply_force_to_cube(drag_vector: Vector2):
	if not selected_cube:
		return
	
	# Convert 2D drag vector to 3D force vector
	# We'll use the camera's orientation to determine the force direction
	var force_direction = Vector3.ZERO
	
	# Get camera basis vectors
	var camera_right = camera.global_transform.basis.x
	var camera_up = camera.global_transform.basis.y
	
	# Calculate force direction based on drag
	force_direction = -camera_right * drag_vector.x - camera_up * drag_vector.y
	force_direction = force_direction.normalized()
	
	# Apply force to the cube
	var force = force_direction * push_force * drag_vector.length() * 0.1
	selected_cube.apply_central_impulse(force)