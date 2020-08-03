extends Node2D


func _ready() -> void:

	$Player.connect("eject_tape", self, "eject_tape")

	for child in get_node("Tapes").get_children():
		if child is VHS_Item:
			child.connect("tape_pickuped", self, "tape_pickuped")
			child.connect("tape_pickuped", $Player, "tape_pickuped")


func tape_pickuped(tape_type) -> void:
	for child in get_node("Tapes").get_children():
		if child is VHS_Item:
			if child.tape_type == tape_type.tape_type:
				get_node("Tapes").remove_child(child)


func eject_tape(tape_type) -> void:
	if tape_type:
		var node_to_load = load("res://src/scenes/entities/VHS/VHS_Item.tscn").instance()
		node_to_load.tape_type = tape_type.tape_type
		node_to_load.position = $Player.position
		node_to_load.rotation = $Player.rotation
		node_to_load.shoot_out(node_to_load.rotation, 7500)

		node_to_load.connect("tape_pickuped", self, "tape_pickuped")
		node_to_load.connect("tape_pickuped", $Player, "tape_pickuped")

		get_node("Tapes").add_child(node_to_load)
