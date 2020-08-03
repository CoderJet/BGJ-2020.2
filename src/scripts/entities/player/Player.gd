class_name Player
extends Entity

signal hit_point(location)

export (float, 0.05, 1.0, 0.05) var smoothing : float = 0.1

onready var hit_scan := get_node("Body/RayCast2D")
onready var legs : AnimatedSprite = get_node("Legs")
onready var tween : Tween = get_node("Tween")
export(float) var weapon_range = 2000

var smoke_particle := preload("res://src/scenes/particles/HitParticles.tscn")
var mouse_pos := Vector2.ZERO
var particle_holder:Node = null

## Public
## Animation
func play_idle() -> void:
	if legs.animation != "idle":
		legs.play("idle")


func play_running() -> void:
	if legs.animation != "running":
		legs.play("running")

## Handlers
func eject() -> void:
	if get_node("VCR").get_children().size() == 1:
		pass

func is_player() -> bool:
	return true

func handle_movement(delta : float) -> void:
	velocity = Vector2.ZERO

	if Input.is_action_pressed('left'):
		velocity.x = -1
	elif Input.is_action_pressed('right'):
		velocity.x = 1

	if Input.is_action_pressed("forward"):
		velocity.y = -1
	elif Input.is_action_pressed("backwards"):
		velocity.y = 1

	velocity = velocity.normalized()#.rotated(rotation).normalized()
	move_and_slide(velocity * speed, FLOOR_NORMAL)
	_handle_legs()

export(float) var cooldown_frames = 2
onready var cur_cooldown_frames = cooldown_frames
func handle_weapon()-> void:
	if Input.is_action_pressed("fire"):
		var diff_x = rand_range(-100, 100)
		var diff_y = rand_range(-50, 50)
		
		if cur_cooldown_frames > 0:
			cur_cooldown_frames = cur_cooldown_frames - 1
		else:
			cur_cooldown_frames = cooldown_frames
			#var pos = get_global_mouse_position()
			var pos = Vector2(0 + diff_x, weapon_range + diff_y)
			hit_scan.cast_to = Vector2(weapon_range + diff_y, diff_x)
			if hit_scan.is_colliding():
				if hit_scan.get_collider().has_method("take_damage"):
					hit_scan.get_collider().take_damage(5)
					emit_signal("hit_point", hit_scan.get_collision_point())
				pos = hit_scan.get_collision_point()
	
			var effect = smoke_particle.instance()
			effect.position = pos
			effect.rotation = rotation
			effect.emitting = true
			if particle_holder == null:
				particle_holder = get_tree().get_root().find_node("Particles", true, false)
#				if particle_holder == null:
#					# Add it.
#					var node = Node2D
#					node.set_name("Particles")
#					get_tree().get_root().add_child(node)
#					particle_holder = node
			particle_holder.add_child(effect)
			
			
			flash = true
			flash_frames = 2
			#var length = pos.distance_to(position) - 330
			$Body/HitScan.points[0] = Vector2(0, 0)
			if hit_scan.is_colliding():
				$Body/HitScan.points[1] = Vector2(diff_x, pos.distance_to(position) - 330)
			else:
				$Body/HitScan.points[1] = Vector2(0 + diff_x, weapon_range + diff_y)
	else:
		cur_cooldown_frames = cooldown_frames

## Private
func _handle_legs() -> void:
	if !tween.is_active():
		var rotate_amount

		if Input.is_action_pressed("left"):
			rotate_amount = -45
		elif Input.is_action_pressed("right"):
			rotate_amount = 45
		else:
			if legs.rotation_degrees != 0:
				rotate_amount = 0

#		if legs.rotation_degrees != rotate_amount:
#			tween.interpolate_property(legs, "rotation_degrees", legs.rotation_degrees, rotate_amount, 0.25, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
#			tween.start()
#			yield(tween, "tween_completed")

## Godot functions
func _ready() -> void:
	play_idle()

var flash = false
var flash_frames = 0
func _process(delta: float) -> void:
	## Rotate the torso inline with the mouse position
	mouse_pos = get_local_mouse_position()
	# Interpret the value in degrees, so we can work with them easier.
	var torso_value = fmod(rad2deg(rotation + (mouse_pos.angle() * smoothing)), 360)
	rotation_degrees = torso_value

	if flash == true:
		if flash_frames == 0:
			flash = false
			$Body/Torso.frame = 0
			$Body/muzzle_flash.visible = false
			$Body/HitScan.visible = false
		else:
			flash_frames = flash_frames - 1
			$Body/Torso.frame = 1
			$Body/muzzle_flash.visible = true
			$Body/HitScan.visible = true
