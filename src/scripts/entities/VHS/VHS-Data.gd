class_name VHS_Data
extends Node

var tape_type : int = Globals.TapeType.Pistol
var spray_x := Vector2()
var spray_y := Vector2()
var gun_damage : int
var shot_delay : float
var max_magixine_size : int
var magazine_size : int
var reload_delay : float

func gun_name() -> String:
	match (tape_type):
		Globals.TapeType.Pistol:
			return "Pistol"
		Globals.TapeType.SubMachineGun:
			return "SMG"
	return "Pistol"
