class_name EnemyPistol
extends Enemy

var color_mod_frames = 4
var cur_frames = 0

onready var hit_scan = $Raycast

func _hit_scan() -> KinematicBody2D:
	var diff_x = rand_range(-100, 100)
	var diff_y = rand_range(-50, 50)
	hit_scan.cast_to = Vector2(diff_x + 2000, diff_y)
	if hit_scan.is_colliding():
		return hit_scan.get_collider()
	return null

func _process(delta):
	#._process(delta)


	if (cur_frames > 0):
		modulate = Color("ff0000")
		cur_frames -= 1
	else:
		modulate = Color("ffffff")

func take_damage(damage : int) -> void:
	cur_frames = color_mod_frames
	.take_damage(damage)

func _body_entered(other : PhysicsBody2D) -> void:
	print("%s : %s" % [other.name, other.collision_layer])
	if other && other.collision_layer == 2:
		queue_free()
		if ![$StateMachine.states.chasing, $StateMachine.states.shoot].has($StateMachine.state):
			# Do a raycast and make sure that we hit the player.
			$StateMachine.state = $StateMachine.states.chasing
			$StateMachine.player = other
