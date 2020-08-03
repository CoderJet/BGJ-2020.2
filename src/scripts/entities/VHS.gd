extends Area2D

signal tape_pickuped

var collectable : bool = false


func _on_body_entered(body: Node) -> void:
	collectable = true


func _on_body_exited(body: Node) -> void:
	collectable = false


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("interact"):
		emit_signal("tape_pickuped")
