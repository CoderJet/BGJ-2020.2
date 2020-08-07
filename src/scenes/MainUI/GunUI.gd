extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func load_gun(name : String, max_size : int, cur_size : int, background_image : String = ""):
	$UI_GUN/BackgroundImage.texture = load(background_image)
	var prog = float(cur_size) / float(max_size)
	$Full.progress = prog
	$Empty.progress = prog
	has_gun = true
	
func unload_gun():
	$UI_GUN/BackgroundImage.texture = load("res://assets/UI/UI_WEAPON_NULL.png")
	$Full.progress = 0
	$Empty.progress = 1
	has_gun = false

var reload_time = 0
var has_gun = false

func tape_pickuped(tape_type) -> void:
	load_gun(tape_type.gun_name(), tape_type.max_magazine_size, tape_type.magazine_size, tape_type.image)
	reload_time = tape_type.reload_delay

func tape_ejected(tape_type) -> void:
	unload_gun()

func lerp_prog(prev_val : float, new_val : float) -> void:
	if has_gun:
		$Tween.interpolate_method($Full, "set_progress", prev_val, new_val, reload_time)
		$Tween.interpolate_method($Empty, "set_progress", prev_val, new_val, reload_time)
		$Tween.start()
