extends Node2D

#export (float, 0.05, 1.0, 0.05) var rotate_smooth : float = 0.1
#
#onready var legs = get_node("../Legs")
#
#var mouse_pos := Vector2.ZERO
#
#func _process(delta: float) -> void:
#	## Rotate the torso inline with the mouse position
#	mouse_pos = get_local_mouse_position()
#	# Interpret the value in degrees, so we can work with them easier.
#	var torso_value = fmod(rad2deg(rotation + (mouse_pos.angle() * rotate_smooth)), 360)
#	rotation_degrees = torso_value
#
#	var legs_value = fmod(legs.rotation_degrees, 360)
#
#	if legs_value > torso_value:
#		print(torso_value >  (legs_value + 45))
#		if torso_value >  (legs_value + 45):
#			legs.rotation_degrees += 45.0
#	else:
#		print("Nass")
