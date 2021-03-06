extends StateMachine

func _ready() -> void:
	add_state("idle")
	add_state("run")
	add_state("reload")
	add_state("die")
	call_deferred("set_state", states.idle)

## State machine logic
func _state_logic(delta : float) -> void:
	if state != states.die:
		parent.handle_movement(delta)

	if [states.idle, states.run].has(state):
		parent.handle_weapon()

	if state == states.reload:
		parent.rewind_tape()

func _get_transition(delta : float):
	# Move between states: run -> reloading
	match state:
		states.idle:
			if parent.reloading:
				return states.reload
			elif parent.velocity != Vector2.ZERO:
				return states.run
		states.run:
			if parent.reloading:
				return states.reload
			elif parent.velocity == Vector2.ZERO:
				return states.idle
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
			Globals._play_clip("VCR SFX_ReloadLong.wav")
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
				parent.rewind_start()
	elif state == states.reload:
		if event.is_action_pressed("eject") || event.is_action_pressed("fire") || parent.is_magazine_full():
			print("Rewind stopped")
			Globals._stop_clip("VCR SFX_ReloadLong.wav")
			parent.rewind_stop()
