extends Node

signal tape_pickuped(tape_type)
signal mouse_pos(mouse_pos)


func _ready() -> void:
	$Player.connect("eject_tape", self, "eject_tape")

	self.connect("tape_pickuped", $Player, "tape_pickuped")
	self.connect("mouse_pos", $Player, "mouse_pos")

	for child in get_node("Tapes").get_children():
		if child is VHS_Item:
			child.connect("tape_pickuped", self, "tape_pickuped")


func tape_pickuped(tape_type) -> void:
	for child in get_node("Tapes").get_children():
		if child is VHS_Item:
			if child.vhs_gun.tape_type == tape_type.tape_type:
				if $Player.current_gun == null:
					get_node("Tapes").remove_child(child)
					emit_signal("tape_pickuped", tape_type)


func eject_tape(tape_type) -> void:
	if tape_type:
		var node_to_load = load("res://src/scenes/entities/VHS/VHS_Item.tscn").instance()
		node_to_load.vhs_gun = tape_type
		node_to_load.position = $Player.position
		node_to_load.rotation = $Player.rotation
		node_to_load.shoot_out(node_to_load.rotation, 10000)

		node_to_load.connect("tape_pickuped", self, "tape_pickuped")
		self.connect("tape_pickuped", $Player, "tape_pickuped")

		get_node("Tapes").add_child(node_to_load)
