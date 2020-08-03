class_name EnemyPistol
extends Enemy

var color_mod_frames = 4
var cur_frames = 0

func _process(delta):
	#._process(delta)


	if (cur_frames > 0):
		modulate = Color("ff0000")
		cur_frames -= 1
	else:
		modulate = Color("ffffff")

func take_damage(damage : int) -> void:
	health -=  damage

	cur_frames = color_mod_frames

	if health <= 0:
		queue_free()

func _body_entered(other : KinematicBody2D) -> void:
	if other:
		if other.has_method("is_player") and other.name == "Player":
			# Do a raycast and make sure that we hit the player.
			pass
