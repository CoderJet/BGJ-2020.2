class_name Entity
extends KinematicBody2D

const FLOOR_NORMAL := Vector2.ZERO

export (float, 100.0, 50000.0, 1.0) var speed : float = 150.0
export (int, 1, 100, 1) var max_health : int = 10
export var take_damage_sfx : String
export var dead_sfx : String

var velocity := Vector2.ZERO
var health : int = 10

func take_damage(damage : int) -> void:
	health -=  damage
	
	if health <= 0:
		print(name, " is dead!")
		if dead_sfx != "":
			Globals._play_clip(dead_sfx)
		queue_free()
	else:
		Globals._play_clip(take_damage_sfx)

func _ready() -> void :
	health = max_health
