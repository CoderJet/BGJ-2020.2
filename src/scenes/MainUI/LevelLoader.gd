extends Viewport


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var cur_level = null
var scenes = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	scenes["Scene1"] = load("res://src/scenes/PlayerPlayground.tscn")
	scenes["Scene2"] = load("res://src/scenes/Scene1-VHSStore/Level-TheStreets.tscn")
	
	load_level("Scene1")

func load_level(scene : String) -> void:
	if scenes.has(scene) == false:
		print("NOT IN SCENE")
		return
	
	if cur_level:
		cur_level.queue_free()
	
	var packed_instance = scenes[scene]
	print(packed_instance)
	if packed_instance:
		var instance = packed_instance.instance()
		cur_level = instance
		add_child(instance)
