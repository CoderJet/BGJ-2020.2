class_name StateMachinePistol
extends StateMachine

onready var player = find_node("Player")

func _ready() -> void:
	add_state("idle")
	add_state("run")
	add_state("reload")
	add_state("shoot")
	add_state("die")
	add_state("chasing")
	add_state("searching")
	call_deferred("set_state", states.idle)

var wait_time = 5
var next_time = 0

var shoot_time = 0.4
var next_time_shoot = 0
## State machine logic
func _state_logic(delta : float) -> void:
	if [states.chasing].has(state):
		parent._move_to(player.position)
		if player.position.distance_to(parent.position) < 2000:
			print ("I'm near you!")
			state = states.shoot
		pass
	
	if [states.shoot].has(state):
		#parent.rotation = (parent.rotation + (player.position.angle() * 0.1))
		#parent.rotation = lerp(parent.rotation, PI + parent.position.angle_to_point(player.position), delta)
		#parent.interpolate_property(parent.rotation)
		Globals.SmoothLookAt(parent, player.position, 0.2)
#		var angle = rad2deg(parent.position.angle_to_point(player.position))
#		print(angle)
#		if angle < 0:
#			parent.rotation_degrees += 1
#			#parent.rotate( deg2rad( AngularLookAt( parent.global_position, parent.global_rotation, player.position, 1 ) ) )
#		elif angle > 0:
#			parent.rotation_degrees -= 1
#		else:
#			pass
		
		if next_time_shoot <= 0:
			next_time_shoot = shoot_time
			var other = parent._hit_scan()
			if other and other.has_method("is_player"):
				other.take_damage(1)
				pass
		else:
			next_time_shoot -= delta
	
	if [states.idle].has(state):
#		if len(parent.path) == 0:
#
#		else:
		next_time -= delta
		if next_time <= 0:
			parent.set_destination()
			state = states.run
		else:
#			parent.rotation += delta * PI * 2 * 1.33
			parent.rotation_degrees += delta * 90
			pass
	if [states.run, states.reload].has(state):
		if parent.move_to_destination():
			state = states.idle
			next_time = wait_time

func _get_transition(delta : float):
	# Move between states: run -> reloading
	match state:
		states.idle:
			if len(parent.path) > 0:
				return states.run
		states.run:
			if len(parent.path) == 0:
				return states.idle
		states.reload:
			pass
		states.die:
			pass
		states.shoot:
			pass
		states.chasing:
			pass
		states.searching:
			pass
	return null


func _enter_state(new_state, old_state) -> void:
	# Handle animations
	match state:
		states.idle:
			pass
		states.run:
			pass
		states.reload:
			pass
		states.die:
			pass
		states.shoot:
			pass
		states.chasing:
			pass
		states.searching:
			pass


func _exit_state(old_sate, new_state) -> void:
	# Handle animations
	match state:
		states.idle:
			pass
		states.run:
			pass
		states.reload:
			pass
		states.die:
			pass
		states.shoot:
			pass
		states.chasing:
			pass
		states.searching:
			pass
