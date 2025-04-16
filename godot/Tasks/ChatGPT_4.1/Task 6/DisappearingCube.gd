extends RigidBody3D

@export var disappear_time: float = 1.5 # Seconds before disappearing
@export var ground_group: String = "ground"
@export var cube_group: String = "disappearing_cube"

var _timer: Timer
var _contacts := {}

func _ready():
	add_to_group(cube_group)
	# Create and configure timer
	_timer = Timer.new()
	_timer.wait_time = disappear_time
	_timer.one_shot = true
	_timer.autostart = false
	_timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(_timer)
	# Connect Area3D signals
	var area = $ContactArea
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group(ground_group) or body.is_in_group(cube_group):
		_contacts[body.get_instance_id()] = true
		if _timer.is_stopped() == false:
			_timer.stop()

func _on_body_exited(body):
	if body.is_in_group(ground_group) or body.is_in_group(cube_group):
		_contacts.erase(body.get_instance_id())
		if _contacts.size() == 0 and _timer.is_stopped():
			_timer.start()

func _on_timer_timeout():
	queue_free()