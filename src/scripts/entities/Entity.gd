class_name Entity
extends KinematicBody2D

signal damage_taken(remaining)

const FLOOR_NORMAL := Vector2.ZERO

export (float, 1.0, 50000.0, 1.0) var speed : float = 150.0
export (int, 1, 100, 1) var max_health : int = 10
export var take_damage_sfx : String
export var dead_sfx : String

var velocity := Vector2.ZERO
var health : int = 5
var is_player = false

func take_damage(damage : int) -> void:
	health -=  damage
	
	if health <= 0:
		print(name, " is dead!")
		if dead_sfx != "":
			Globals._play_clip(dead_sfx)
	else:
		Globals._play_clip(take_damage_sfx)
		emit_signal("damage_taken", health)
		
func _ready() -> void :
	health = max_health
