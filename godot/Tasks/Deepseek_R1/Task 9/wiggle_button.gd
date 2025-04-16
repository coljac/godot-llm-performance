@tool
extends Button

@export_range(0, 2.0) var intensity: float = 0.5:
	set(value):
		intensity = value
		material.set_shader_parameter("intensity", intensity)

var shader = preload("res://Tasks/Deepseek_R1/Task 9/wiggle_button.gdshader")

func _ready():
	material = ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("intensity", intensity)
	
func _notification(what):
	if what == NOTIFICATION_MOUSE_ENTER:
		material.set_shader_parameter("active", true)
	elif what == NOTIFICATION_MOUSE_EXIT:
		material.set_shader_parameter("active", false)
