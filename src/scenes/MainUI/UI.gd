extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _start_rewind():
	$ScanLineEffect.material.set_shader_param("lines", true)
	$UI_REWINDER.frame = 3

func _stop_rewind():
	$ScanLineEffect.material.set_shader_param("lines", false)
	$UI_REWINDER.frame = 2

func _took_damage(health : int):
	$UI_SHAMEBOY/UI_HEALTH_000.frame-=1
