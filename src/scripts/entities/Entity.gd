class_name Entity
extends KinematicBody2D

const FLOOR_NORMAL := Vector2.ZERO

export (float, 100.0, 50000.0, 1.0) var speed : float = 150.0
export (int, 1, 100, 1) var max_health : int = 10

var velocity := Vector2.ZERO
var health : int = 10


func _ready() -> void :
	health = max_health
