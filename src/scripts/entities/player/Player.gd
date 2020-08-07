class_name Player
extends Entity

signal hit_point(location)
signal eject_tape(tape_type)
signal rewind_bullet(prog, new_prog)
signal rewind_started()
signal rewind_stopped()

#export (float, 0.05, 1.0, 0.05) var smoothing : float = 0.1
export (float) var weapon_range = 2000
export (float) var dash_speed = 4000
export (float) var dash_time = 0.5

onready var hit_scan 		: RayCast2D			= get_node("Body/RayCast2D")
onready var legs 			: AnimatedSprite 	= get_node("Legs")
onready var torso 			: AnimatedSprite 	= get_node("Body/Torso")
onready var tween 			: Tween 			= get_node("Tween")
onready var shot_delay 		: Timer 			= get_node("ShotDelay")
onready var reload_delay 	: Timer 			= get_node("ReloadDelay")

var smoke_particle := preload("res://src/scenes/particles/HitParticles.tscn")
var mouse_pos 		: Vector2 = Vector2.ZERO
var particle_holder : Node = null

var current_gun = null
var flash = false
var flash_frames = 0
var reloading : bool = false

#Dashing
var dashing = false
var dash_cooldown = 0
var direction = Vector2(0,0)
var direction_angle = 0

## Public
## Animation
func play_idle() -> void:
	if current_gun:
		torso.play("idle")
	else:
		torso.play("gunless")
	legs.play("idle")

func play_running() -> void:
	if current_gun:
		torso.play("idle")
	else:
		torso.play("gunless")
	legs.play("running")

## Handlers
## Checks
func is_player() -> bool:
	return true

func requires_reloading() -> bool:
	return current_gun.magazine_size < current_gun.max_magazine_size


func is_magazine_full() -> bool:
	return current_gun.magazine_size == current_gun.max_magazine_size

## Player functionality
func eject() -> void:
	emit_signal("eject_tape", current_gun)
	if current_gun:
		Globals._play_clip("VCR SFX_HeadThrow.wav")
	current_gun = null


func tape_pickuped(tape_type) -> void:
	current_gun = tape_type
	shot_delay.wait_time = tape_type.shot_delay
	reload_delay.wait_time = tape_type.reload_delay


func handle_movement(delta : float) -> void:
	velocity = Vector2.ZERO
	var new_speed = speed

	if dashing:
		dash_cooldown -= delta
		velocity = direction
		new_speed = dash_speed
		if dash_cooldown <= 0:
			dash_cooldown = 0
			dashing = false
			$Legs.visible = true
			torso.scale = Vector2(1, 1)
			torso.rotation_degrees = 0
			if !current_gun:
				torso.play("gunless")
			else:
				torso.play("gunning")
				torso.stop()
				torso.frame = 0
	else:
		if Input.is_action_pressed('left'):
			velocity.x = -1
		elif Input.is_action_pressed('right'):
			velocity.x = 1

		if Input.is_action_pressed("forward"):
			velocity.y = -1
		elif Input.is_action_pressed("backwards"):
			velocity.y = 1

		velocity = velocity.normalized()

		if Input.is_action_just_pressed("dash") and current_gun and !reloading:
			if velocity.x != 0 || velocity.y != 0:
				direction = velocity
				direction_angle = $Legs.rotation_degrees
				dash_cooldown = dash_time
				dashing = true
				$Legs.visible = false
				torso.play("dodging")
				if velocity.x < 0 and velocity.y == 0:
					torso.scale.x = -1

	if reloading:
		new_speed /= 2

	move_and_slide(velocity * new_speed, FLOOR_NORMAL)
	_handle_legs()

func take_damage(damage : int) -> void:
	if dashing:
		return
	
	.take_damage(damage)
	if health <= 0:
		$"/root/Control/ViewportContainer/Viewport".reload_level()

func handle_weapon()-> void:
	if !current_gun:
		return

	if dashing:
		return

	if Input.is_action_pressed("fire"):
		if shot_delay.is_stopped() && current_gun.magazine_size != 0:
			Globals._play_clip(current_gun.audio_clip)
			var diff_x = rand_range(current_gun.spray_x.x, current_gun.spray_x.y)
			var diff_y = rand_range(current_gun.spray_y.x, current_gun.spray_y.y)

			var pos = Vector2.ZERO
			hit_scan.cast_to = Vector2(weapon_range + diff_y, diff_x)

			if hit_scan.is_colliding():
				if hit_scan.get_collider().has_method("take_damage"):
					hit_scan.get_collider().take_damage(current_gun.gun_damage)
					emit_signal("hit_point", hit_scan.get_collision_point())
				pos = hit_scan.get_collision_point()
				_create_impact(pos)

			_handle_gun_flash(pos, diff_x, diff_y)
			var prog = float(current_gun.magazine_size) / float(current_gun.max_magazine_size)
			var prog_new = float(current_gun.magazine_size-1) / float(current_gun.max_magazine_size)
			emit_signal("rewind_bullet", prog, prog_new)

			current_gun.magazine_size -= 1
			shot_delay.start()

func rewind_start() -> bool:
	if !dashing:
		reloading = true
		emit_signal("rewind_started")
		return true
	return false

func rewind_stop() -> void:
	reloading = false
	emit_signal("rewind_stopped")

func rewind_tape() -> void:
	if reload_delay.is_stopped():
		if !is_magazine_full():

			var prog = float(current_gun.magazine_size)/float(current_gun.max_magazine_size)
			var new_prog = float(current_gun.magazine_size+1)/float(current_gun.max_magazine_size)

			emit_signal("rewind_bullet", prog, new_prog)
			current_gun.magazine_size += 1
			reload_delay.start()
		else:
			rewind_stop()
			Globals._stop_clip("VCR SFX_ReloadLong.wav")

## Private
func _create_impact(pos : Vector2) -> void:
	var effect = smoke_particle.instance()
	effect.position = pos
	effect.rotation = rotation
	effect.emitting = true
	if particle_holder == null:
		particle_holder = get_tree().get_root().find_node("Particles", true, false)
	particle_holder.add_child(effect)


func _handle_gun_flash(pos : Vector2, offset_x : float, offset_y : float) -> void:
	flash = true
	flash_frames = 2
	#var length = pos.distance_to(position) - 330
	$Body/HitScan.points[0] = Vector2(0, 0)
	if hit_scan.is_colliding():
		$Body/HitScan.points[1] = Vector2(offset_x, pos.distance_to(position) - 330)
	else:
		$Body/HitScan.points[1] = Vector2(0 + offset_x, weapon_range + offset_y)

func _handle_legs() -> void:
	var angle = 0
	if Input.is_action_pressed("forward"):
		angle = -90
		if Input.is_action_pressed("left"):
			angle -= 45
		if Input.is_action_pressed("right"):
			angle += 45

	if Input.is_action_pressed("backwards"):
		angle = 90
		if Input.is_action_pressed("left"):
			angle += 45
		if Input.is_action_pressed("right"):
			angle -= 45

	$Legs.rotation_degrees = angle

## Godot functions
func _ready() -> void:
	is_player = true
	play_idle()

func _process(delta: float) -> void:
	## Rotate the torso inline with the mouse position
	if !dashing:
		$Body.look_at(get_global_mouse_position())
	else:
		$Body.rotation_degrees = direction_angle

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
