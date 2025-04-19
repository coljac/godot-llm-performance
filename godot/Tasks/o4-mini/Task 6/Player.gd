extends CharacterBody3D

@export var speed: float = 5.0
@export var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
    var input_dir = Vector3.ZERO
    if Input.is_action_pressed("ui_up"):
        input_dir.z -= 1
    if Input.is_action_pressed("ui_down"):
        input_dir.z += 1
    if Input.is_action_pressed("ui_left"):
        input_dir.x -= 1
    if Input.is_action_pressed("ui_right"):
        input_dir.x += 1
    input_dir = input_dir.normalized()

    velocity.y -= gravity * delta
    velocity.x = input_dir.x * speed
    velocity.z = input_dir.z * speed

    move_and_slide()