extends Node2D

signal tape_pickuped(tape_type)


func _ready() -> void:
	$Player.connect("eject_tape", self, "eject_tape")

	for child in get_node("Tapes").get_children():
		if child is VHS_Item:
			print(child.vhs_gun.gun_name())
			child.connect("tape_pickuped", self, "tape_pickuped")
			self.connect("tape_pickuped", $Player, "tape_pickuped")


func tape_pickuped(tape_type) -> void:
	for child in get_node("Tapes").get_children():
		if child is VHS_Item:
			print("============")
			print(tape_type.gun_name())
			print("In world: %s" % [child.vhs_gun.gun_name()])
			if child.vhs_gun.tape_type == tape_type.tape_type:
				if $Player.current_gun == null:
					print("3")
					get_node("Tapes").remove_child(child)
					emit_signal("tape_pickuped", tape_type)


func eject_tape(tape_type) -> void:
	if tape_type:
		var node_to_load = load("res://src/scenes/entities/VHS/VHS_Item.tscn").instance()
		node_to_load.vhs_gun = tape_type
		node_to_load.position = $Player.position
		node_to_load.rotation = $Player.rotation
		node_to_load.shoot_out(node_to_load.rotation, 7500)

		node_to_load.connect("tape_pickuped", self, "tape_pickuped")
		self.connect("tape_pickuped", $Player, "tape_pickuped")

		get_node("Tapes").add_child(node_to_load)