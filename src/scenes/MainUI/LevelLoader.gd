extends Viewport


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var cur_level = null
var cur_level_str = ""
var scenes = {}
var scene_music = {}

onready var animation : Tween = get_node("../../UI/Tween")
onready var timer : Timer = get_node("../../UI/Timer")

# Called when the node enters the scene tree for the first time.
func _ready():
	scenes["Play"] = load("res://src/scenes/PlayerPlayground.tscn")
	scenes["Scene1"] = load("res://src/scenes/Scene1-VHSStore/Scene1-VHSStore.tscn")
	scenes["Scene2"] = load("res://src/scenes/Scene1-VHSStore/Scene2-TheMall.tscn")
	scenes["Scene3"] = load("res://src/scenes/Scene1-VHSStore/Level-TheStreets.tscn")

	#scene_music["Scene1"] = { "name": "VCR Music_mainLoop02.ogg", "volume": 5, "mixer": "Master" }
	scene_music["Scene1"] = { "name": "VCR_Music_Mall_remix_NO_FILTER.ogg", "volume": 0, "mixer": "Master" }
	scene_music["Scene2"] = { "name": "VCR_Music_Mall_remix_NO_FILTER.ogg", "volume": 5, "mixer": "Mallsoft" }
	scene_music["Scene3"] = { "name": "", "volume": 5, "mixer": "Master" }

	Globals._play_song("VCR Jingle_Intro01.wav", -10, "Mallsoft")
	timer.start()
	yield(timer, "timeout")
	Globals._play_clip("VCR.wav")
	timer.start()
	yield(timer, "timeout")

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

		#instance.connect("next_level", self, "load_level")

		if (scene_music.has(scene)):
			Globals._play_song(scene_music[scene]["name"], scene_music[scene]["volume"], scene_music[scene]["mixer"])


func _input(event: InputEvent) -> void:
	if get_node("../../UI/SPLASH").visible:
		if timer.is_stopped() && event.is_action_pressed("dash"):
			get_node("../../UI/SPLASH").visible = false
			load_level("Scene1")
