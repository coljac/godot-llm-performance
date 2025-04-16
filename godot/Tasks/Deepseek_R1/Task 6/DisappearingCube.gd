extends RigidBody3D

var contact_count = 0
@export_range(0.1, 10.0) var timer_duration := 2.0

func _ready():
    $Timer.wait_time = timer_duration
    $Timer.timeout.connect(Callable(self, "_on_Timer_timeout"))
    body_entered.connect(Callable(self, "_on_body_entered"))
    body_exited.connect(Callable(self, "_on_body_exited"))

func _on_body_entered(body):
    if body.is_in_group("ground") || body.has_method("is_disappearing_cube"):
        contact_count += 1
        $Timer.stop()

func _on_body_exited(body):
    if body.is_in_group("ground") || body.has_method("is_disappearing_cube"):
        contact_count -= 1
        if contact_count <= 0:
            contact_count = 0
            $Timer.start()

func _on_Timer_timeout():
    if contact_count == 0:
        queue_free()

func is_disappearing_cube():
    return true