extends Viewport


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var cur_level = null
var cur_level_str = ""
var scenes = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	scenes["Scene1"] = load("res://src/scenes/PlayerPlayground.tscn")
	scenes["Scene2"] = load("res://src/scenes/Scene1-VHSStore/Level-TheStreets.tscn")
	scenes["Scene3"] = load("res://src/scenes/Scene1-VHSStore/Scene1-VHSStore.tscn")

	load_level("Scene1")

func reload_level() -> void:
	if cur_level:
		$"../../UI/UI_SHAMEBOY/UI_HEALTH_000".frame = 4
		load_level(cur_level_str)

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
		cur_level_str = scene
		add_child(instance)
