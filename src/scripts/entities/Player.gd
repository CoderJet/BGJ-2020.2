class_name Player
extends Entity

signal hit_point(location)

onready var hit_scan := get_node("Torso/RayCast2D")
var hit_part := preload("res://src/scenes/particles/HitParticles.tscn")


func _handle_movement(delta : float) -> void:
	velocity = Vector2.ZERO
	velocity.x = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))
	velocity.y = -int(Input.is_action_pressed("forward")) + int(Input.is_action_pressed("backwards"))

	velocity *= speed

	move_and_slide(velocity, FLOOR_NORMAL)


func _handle_weapon()-> void:
	if Input.is_action_just_pressed("fire") && hit_scan.is_colliding():
		print("Hit: %s" % hit_scan.get_collider())
		if hit_scan.get_collider().has_method("take_damage"):
			hit_scan.get_collider().take_damage(5)

#		var effect = hit_part.instance()
#		add_child(effect)
#		effect.position = get_global_mouse_position()#hit_scan.get_collision_point()
#		effect.emitting = true
		emit_signal("hit_point", hit_scan.get_collision_point())
