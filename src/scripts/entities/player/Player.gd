class_name Player
extends Entity

signal hit_point(location)

export (float, 0.05, 1.0, 0.05) var smoothing : float = 0.1

onready var hit_scan := get_node("Body/RayCast2D")
onready var legs : AnimatedSprite = get_node("Legs")
onready var tween : Tween = get_node("Tween")

var smoke_particle := preload("res://src/scenes/particles/HitParticles.tscn")
var mouse_pos := Vector2.ZERO

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


func handle_weapon()-> void:
	if Input.is_action_just_pressed("fire") && hit_scan.is_colliding():
		if hit_scan.get_collider().has_method("take_damage"):
			hit_scan.get_collider().take_damage(5)

		var effect = smoke_particle.instance()
		effect.position = hit_scan.get_collision_point()
		effect.rotation = rotation
		effect.emitting = true
		get_tree().get_root().get_node("/root/PlayerPlayground/Particles").add_child(effect)

		emit_signal("hit_point", hit_scan.get_collision_point())

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

		if legs.rotation_degrees != rotate_amount:
			tween.interpolate_property(legs, "rotation_degrees", legs.rotation_degrees, rotate_amount, 0.25, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			tween.start()
			yield(tween, "tween_completed")

## Godot functions
func _ready() -> void:
	play_idle()


func _process(delta: float) -> void:
	## Rotate the torso inline with the mouse position
	mouse_pos = get_local_mouse_position()
	# Interpret the value in degrees, so we can work with them easier.
	var torso_value = fmod(rad2deg(rotation + (mouse_pos.angle() * smoothing)), 360)
	rotation_degrees = torso_value