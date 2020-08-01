extends StateMachine

func _ready() -> void:
	add_state("idle")
	add_state("run")
	add_state("reload")
	add_state("die")
	call_deferred("set_state", states.idle)

## State machine logic
func _state_logic(delta : float) -> void:
	if [states.idle].has(state):
		if len(parent.path) == 0:
			parent.set_destination()
	if [states.run, states.reload].has(state):
		parent.move_to_destination()


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
