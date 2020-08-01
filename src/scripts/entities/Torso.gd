extends Node2D

export (float, 0.05, 1.0, 0.05) var rotate_smooth : float = 0.1

var mouse_pos := Vector2.ZERO

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
#	mouse_pos = get_local_mouse_position()
#	rotation += mouse_pos.angle() * rotate_smooth
