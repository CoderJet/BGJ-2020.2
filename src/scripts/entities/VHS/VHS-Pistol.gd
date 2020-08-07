extends VHS_Data

func _init() -> void:
	self.tape_type = Globals.TapeType.Pistol
	self.spray_x = Vector2(-50, 50)
	self.spray_y = Vector2(-50, 50)
	self.gun_damage = 10
	self.max_magazine_size = 6
	self.magazine_size = self.max_magazine_size
	self.shot_delay = 0.25
	self.reload_delay = 0.1
