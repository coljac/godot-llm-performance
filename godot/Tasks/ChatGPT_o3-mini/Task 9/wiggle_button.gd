@tool
extends Button

@export_range(0, 2.0)
var intensity: float = 0.5:
	set(value):
		intensity = value
		if shader_material:
			shader_material.set_shader_parameter("intensity", intensity)

var shader_material: ShaderMaterial
var shader = preload("res://Tasks/ChatGPT_o3-mini/Task 9/wiggle_button.gdshader")

func _ready():
	shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	shader_material.set_shader_parameter("intensity", intensity)
	self.material = shader_material

func _notification(what):
	if what == NOTIFICATION_MOUSE_ENTER:
		print("Mouse entered button")
		shader_material.set_shader_parameter("active", true)
	elif what == NOTIFICATION_MOUSE_EXIT:
		shader_material.set_shader_parameter("active", false)
