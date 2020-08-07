class_name VHS_Data
extends Node

export var tape_type : int = Globals.TapeType.Pistol
export var spray_x := Vector2()
export var spray_y := Vector2()
export var gun_damage : int
export var shot_delay : float
export var max_magazine_size : int
export var magazine_size : int
export var reload_delay : float
export var audio_clip : String
export var image : String

func gun_name() -> String:
	match (tape_type):
		Globals.TapeType.Pistol:
			return "Pistol"
		Globals.TapeType.SubMachineGun:
			return "SMG"
	return "Pistol"
