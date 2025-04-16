extends RigidBody3D

class_name DisappearingCube

# Time in seconds before the cube disappears when not in contact
@export var disappear_time: float = 2.0

# Timer to track how long the cube has been without contact
var disappear_timer: float = 0.0

# Flag to track if the cube is in contact with a valid surface
var is_in_contact: bool = false

# List of bodies currently in contact with this cube
var contact_bodies: Array = []

func _ready():
	# Set up collision detection
	contact_monitor = true
	max_contacts_reported = 10
	
	# Connect signals for collision detection
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Initial check for ground contact
	await get_tree().process_frame
	_check_contact_status()

func _process(delta):
	# If not in contact with a valid surface, increment the timer
	if not is_in_contact:
		disappear_timer += delta
		if disappear_timer >= disappear_time:
			queue_free()
	else:
		# Reset the timer when in contact
		disappear_timer = 0.0

func _on_body_entered(body):
	# Add body to contacts list
	if not contact_bodies.has(body):
		contact_bodies.append(body)
	
	# Update contact status
	_check_contact_status()

func _on_body_exited(body):
	# Remove body from contacts list
	if contact_bodies.has(body):
		contact_bodies.erase(body)
	
	# Update contact status
	_check_contact_status()

func _check_contact_status():
	# Reset contact status
	is_in_contact = false
	
	# Check each body in contact
	for body in contact_bodies:
		# If it's the ground (static body) or another disappearing cube, we're in contact
		if body is StaticBody3D or body is DisappearingCube:
			is_in_contact = true
			break