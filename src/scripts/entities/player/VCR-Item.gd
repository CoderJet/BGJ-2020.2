class_name VHS_Item
extends RigidBody2D

export (Globals.TapeType) var tape_type := Globals.TapeType.Pistol

signal tape_pickuped(vhs_tape)

var collectable : bool = false
var vhs_pistol := preload("res://src/scripts/entities/VHS/VHS-Pistol.gd").new()
var vhs_smg := preload("res://src/scripts/entities/VHS/VHS-SMG.gd").new()

var vhs_gun

func generate_pistol() -> void:
	vhs_gun = vhs_pistol


func generate_smg() -> void:
	vhs_gun = vhs_smg


func _ready() -> void:
	match (tape_type):
		Globals.TapeType.Pistol:
			generate_pistol()
		Globals.TapeType.SubMachineGun:
			generate_smg()


func shoot_out(angle : float, force : float) -> void:
	apply_central_impulse(Vector2(cos(angle), sin(angle)) * force)


func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		collectable = true


func _on_body_exited(body: Node) -> void:
	if body.name == "Player":
		collectable = false


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("interact") && collectable:
		emit_signal("tape_pickuped", vhs_gun)
