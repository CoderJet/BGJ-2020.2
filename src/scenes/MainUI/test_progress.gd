extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(float) var progress = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

export(bool) var ping_pong = false
export(bool) var full = false

func _process(delta):
	var prog = 1.0 - progress if full else progress
	var scale = lerp(0.5, 3.0, prog)
	rect_scale.x = scale
	rect_scale.y = scale

func set_progress(progress : float) -> void:
	self.progress = progress

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
