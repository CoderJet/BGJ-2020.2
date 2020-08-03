class_name VHS
extends Node

var tape_type : int = Globals.TapeType.Pistol


func get_name() -> String:
	match (tape_type):
		Globals.TapeType.Pistol:
			return "Pistol"
		Globals.TapeType.SubMachineGun:
			return "SMG"
	return "Pistol"
