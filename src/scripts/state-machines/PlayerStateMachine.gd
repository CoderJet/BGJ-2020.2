extends StateMachine

func _ready() -> void:
	add_state("idle")
	add_state("run")
	add_state("reload")
	add_state("die")
	call_deferred("set_state", states.idle)

## State machine logic
func _state_logic(delta : float) -> void:
	if [states.idle, states.run, states.reload].has(state):
		parent.handle_movement(delta)
		parent.handle_legs()
		parent.handle_weapon()
	else:
		pass


func _get_transition(delta : float):
	# Move between states: run -> reloading
	match state:
		states.idle:
			if parent.velocity != Vector2.ZERO:
				return states.run
		states.run:
			if parent.velocity == Vector2.ZERO:
				return states.idle
		states.reload:
			pass
		states.die:
			pass
	return null


func _enter_state(new_state, old_state) -> void:
	# Handle animations
	match state:
		states.idle:
			parent.play_idle()
		states.run:
			parent.play_running()
		states.reload:
			pass
		states.die:
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

## Godot functions
func _input(event: InputEvent) -> void:
	pass
