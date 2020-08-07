class_name EnemyPistol
extends Enemy

var color_mod_frames = 4
var cur_frames = 0
var flash = false
var flash_frames = 2

onready var hit_scan = $Raycast

func _hit_scan() -> KinematicBody2D:
	var diff_x = rand_range(-200, 200)
	var diff_y = rand_range(-100, 100)
	hit_scan.cast_to = Vector2(diff_x + $StateMachine.gun_distance, diff_y)
	if hit_scan.is_colliding():
		if randf() < $StateMachine.hit_chance:
			return hit_scan.get_collider()
	return null

func set_flash():
	flash = true
	flash_frames = 2

func _process(delta):
	if modulate.a <= 0:
		queue_free()
		
	if health <= 0:
		return
	
	#._process(delta)
	if (cur_frames > 0):
		modulate = Color("ff0000")
		cur_frames -= 1
	else:
		modulate = Color("ffffff")
	
	if flash == true:
		if flash_frames == 0:
			flash = false
			$Body.frame = 0
			$Body/muzzle_flash.visible = false
			#$Body/HitScan.visible = false
		else:
			flash_frames = flash_frames - 1
			$Body.frame = 1
			$Body/muzzle_flash.visible = true
			#$Body/HitScan.visible = true

func take_damage(damage : int) -> void:
	cur_frames = color_mod_frames
	.take_damage(damage)
	if health <= 0:
		$Body.play("die")
		scale.x = 0.75
		scale.y = 0.75
		modulate = Color("ffffff")
		$StateMachine.state = $StateMachine.states.die
		$Tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 4.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
		$CollisionShape2D.disabled = true
		$Particles/DeathParticles.emitting = true
	else:
		$StateMachine.state = $StateMachine.states.chasing
		$StateMachine.player = get_tree().root.find_node("Player", true, false)

func _body_entered(other : PhysicsBody2D) -> void:
	if $StateMachine.state == $StateMachine.states.die:
		return
	
	if other && other.collision_layer == 1:
		if ![$StateMachine.states.chasing, $StateMachine.states.shoot].has($StateMachine.state):
			# Do a raycast and make sure that we hit the player.
			$StateMachine.state = $StateMachine.states.chasing
			$StateMachine.player = other
