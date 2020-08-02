class_name Player
extends Entity

signal hit_point(location)

onready var hit_scan := get_node("Body/RayCast2D")
onready var legs : AnimatedSprite = get_node("Legs")


var hit_part := preload("res://src/scenes/particles/HitParticles.tscn")


func _ready() -> void:
	play_idle()


func play_idle() -> void:
	if legs.animation != "idle":
		legs.play("idle")


func play_running() -> void:
	if legs.animation != "running":
		legs.play("running")


func handle_movement(delta : float) -> void:
	velocity = Vector2.ZERO

	if Input.is_action_pressed('backwards'):
		velocity.x = -1
	elif Input.is_action_pressed('forward'):
		velocity.x = 1

	if Input.is_action_pressed("left"):
		velocity.y = -1
	elif Input.is_action_pressed("right"):
		velocity.y = 1

	velocity = velocity.rotated(rotation).normalized()

	move_and_slide(velocity * speed, FLOOR_NORMAL)


func handle_legs() -> void:
	if Input.is_action_pressed("left"):
		legs.rotation_degrees = -45
	elif Input.is_action_pressed("right"):
		legs.rotation_degrees = 45
	else:
		legs.rotation_degrees = 0


func handle_weapon()-> void:
	if Input.is_action_just_pressed("fire") && hit_scan.is_colliding():
		if hit_scan.get_collider().has_method("take_damage"):
			hit_scan.get_collider().take_damage(5)

		var effect = hit_part.instance()
		effect.position = hit_scan.get_collision_point()
		effect.rotation = rotation
		effect.emitting = true
		get_tree().get_root().get_node("/root/PlayerPlayground/Particles").add_child(effect)

		emit_signal("hit_point", hit_scan.get_collision_point())


export (float, 0.05, 1.0, 0.05) var rotate_smooth : float = 0.1

#onready var legs = get_node("Legs")

var mouse_pos := Vector2.ZERO

func _process(delta: float) -> void:
	## Rotate the torso inline with the mouse position
	mouse_pos = get_local_mouse_position()
	# Interpret the value in degrees, so we can work with them easier.
	var torso_value = fmod(rad2deg(rotation + (mouse_pos.angle() * rotate_smooth)), 360)
	rotation_degrees = torso_value
#
#	var legs_value = fmod(legs.rotation_degrees, 360)
#
#	if legs_value > torso_value:
#		print(torso_value >  (legs_value + 45))
#		if torso_value >  (legs_value + 45):
#			legs.rotation_degrees += 45.0
#	else:
#		print("Nass")
