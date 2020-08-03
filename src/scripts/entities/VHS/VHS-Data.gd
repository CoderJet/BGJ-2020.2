class_name VHS_Data
extends Node

var tape_type : int = Globals.TapeType.Pistol
var spray_x := Vector2()
var spray_y := Vector2()
var cooldown : float

func get_name() -> String:
	match (tape_type):
		Globals.TapeType.Pistol:
			return "Pistol"
		Globals.TapeType.SubMachineGun:
			return "SMG"
	return "Pistol"
