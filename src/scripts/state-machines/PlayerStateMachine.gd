extends StateMachine

func _ready() -> void:
	add_state("idle")
	add_state("run")
	add_state("reload")
	add_state("die")
	call_deferred("set_state", states.idle)

## State machine logic
func _state_logic(delta : float) -> void:
	if [states.idle, states.run].has(state):
		parent.handle_movement(delta)
		parent.handle_weapon()
	elif state == states.reload:
		parent.rewind_tape()
		parent.handle_movement(delta)
		pass


func _get_transition(delta : float):
	# Move between states: run -> reloading
	match state:
		states.idle:
			if parent.velocity != Vector2.ZERO && !parent.reloading:
				return states.run
			elif parent.reloading:
				return states.reload
		states.run:
			if parent.velocity == Vector2.ZERO && !parent.reloading:
				return states.idle
			elif parent.reloading:
				return states.reload
		states.reload:
			if !parent.reloading:
				return states.idle
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
			print("*Rewind sounds*")
			# Throwup rewind shader?
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
	if [states.idle, states.run].has(state):
		if event.is_action_pressed("eject"):
			parent.eject()
		if parent.current_gun && parent.requires_reloading():
			if event.is_action_pressed("reload"):
				parent.reloading = true
	elif state == states.reload:
		if event.is_action_pressed("eject") || event.is_action_pressed("fire") || parent.is_magazine_full():
			print("Rewind stopped")
			parent.reloading = false
