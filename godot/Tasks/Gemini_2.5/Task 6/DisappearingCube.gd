# DisappearingCube.gd
extends RigidBody3D
class_name DisappearingCube

## Time in seconds before the cube disappears when not supported.
@export var disappear_delay: float = 2.0

@onready var timer: Timer = $Timer
@onready var collision_shape: CollisionShape3D = $CollisionShape3D # Assuming this is the name

# Keep track of bodies currently supporting this cube
var supporting_bodies: Array[Node] = []

func _ready() -> void:
	# Ensure the cube is added to a group for easy identification
	add_to_group("disappearing_cube")
	# Connect signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	timer.timeout.connect(_on_timer_timeout)
	# Set timer properties
	timer.wait_time = disappear_delay
	timer.one_shot = true
	# Initial check in case it spawns mid-air
	# Give physics engine a frame to settle contacts
	await get_tree().physics_frame
	_check_support()

func _on_body_entered(body: Node) -> void:
	if body is StaticBody3D or body is DisappearingCube:
		if not supporting_bodies.has(body):
			supporting_bodies.append(body)
			# print(name, " entered contact with ", body.name, " | Support count: ", supporting_bodies.size())
			_check_support()

func _on_body_exited(body: Node) -> void:
	if supporting_bodies.has(body):
		supporting_bodies.erase(body)
		# print(name, " exited contact with ", body.name, " | Support count: ", supporting_bodies.size())
		_check_support()

func _check_support() -> void:
	if supporting_bodies.is_empty():
		if timer.is_stopped():
			# print(name, " starting timer")
			timer.start()
	else:
		if not timer.is_stopped():
			# print(name, " stopping timer")
			timer.stop()

func _on_timer_timeout() -> void:
	# print(name, " timed out, queueing free")
	queue_free()

# Optional: Add visual feedback when timer starts/stops
# func _process(delta):
#	 if not timer.is_stopped():
#		 modulate.a = lerp(modulate.a, 0.5, delta * 5.0) # Fade slightly
#	 else:
#		 modulate.a = lerp(modulate.a, 1.0, delta * 5.0) # Fade back in