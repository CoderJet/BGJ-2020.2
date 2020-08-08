extends Node

signal tape_pickuped(tape_type)
signal mouse_pos(mouse_pos)
signal next_level(level_name)

var scene_idx = 1


func _ready() -> void:

	$Player.connect("eject_tape", self, "eject_tape")
	Globals._play_song("VCR Music_mainLoop02.ogg", -15)
	var gun_node = get_node("/root/Control/UI/Gun")
	if gun_node:
		gun_node.unload_gun()

	self.connect("tape_pickuped", $Player, "tape_pickuped")
	self.connect("tape_pickuped", gun_node, "tape_pickuped")
	$Player.connect("eject_tape", gun_node, "tape_ejected")
	$Player.connect("rewind_bullet", gun_node, "lerp_prog")
	$Player.connect("rewind_started", get_node("/root/Control/UI"), "_start_rewind")
	$Player.connect("rewind_stopped", get_node("/root/Control/UI"), "_stop_rewind")
	$Player.connect("damage_taken", get_node("/root/Control/UI"), "_took_damage")
	self.connect("mouse_pos", $Player, "mouse_pos")

	if !$Player.current_gun:
		emit_signal("tape_pickuped", load("res://src/scripts/entities/VHS/VHS-Pistol.gd").new())

	for child in get_node("Tapes").get_children():
		if child is VHS_Item:
			child.connect("tape_pickuped", self, "tape_pickuped")


func tape_pickuped(tape_type) -> void:
	for child in get_node("Tapes").get_children():
		if child is VHS_Item:
			if child.vhs_gun.tape_type == tape_type.tape_type:
				if $Player.current_gun == null:
					Globals._play_clip("VCR SFX_WeaponPickup.wav")
					get_node("Tapes").remove_child(child)
					emit_signal("tape_pickuped", tape_type)


func eject_tape(tape_type) -> void:
	if tape_type:
		var node_to_load = load("res://src/scenes/entities/VHS/VHS_Item.tscn").instance()
		node_to_load.vhs_gun = tape_type
		node_to_load.position = $Player.position
		node_to_load.rotation = $Player/Body.rotation
		node_to_load.shoot_out(node_to_load.rotation, 10000)

		node_to_load.connect("tape_pickuped", self, "tape_pickuped")
		self.connect("tape_pickuped", $Player, "tape_pickuped")

		get_node("Tapes").add_child(node_to_load)


func _on_exit(body: Node) -> void:
	emit_signal("next_level", "Scene1")
