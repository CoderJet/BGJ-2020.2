extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _start_rewind():
	$ScanLineEffect.material.set_shader_param("lines", true)
	
func _stop_rewind():
	$ScanLineEffect.material.set_shader_param("lines", false)
