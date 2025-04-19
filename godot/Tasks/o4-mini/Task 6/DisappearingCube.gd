extends RigidBody3D
@export var disappear_time: float = 2.0

var contact_count: int = 0
var timer: Timer

func _ready():
    # Setup timer
    timer = Timer.new()
    timer.wait_time = disappear_time
    timer.one_shot = true
    timer.connect("timeout", Callable(self, "_on_timer_timeout"))
    add_child(timer)
    # Connect collision signals
    self.connect("body_entered", Callable(self, "_on_body_entered"))
    self.connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body: Node) -> void:
    if body is StaticBody3D or body is RigidBody3D:
        contact_count += 1
        if not timer.is_stopped():
            timer.stop()

func _on_body_exited(body: Node) -> void:
    if body is StaticBody3D or body is RigidBody3D:
        contact_count = max(contact_count - 1, 0)
        if contact_count == 0:
            timer.start()

func _on_timer_timeout() -> void:
    queue_free()