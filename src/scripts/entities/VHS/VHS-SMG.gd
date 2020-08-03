extends VHS_Data

func _init() -> void:
	self.tape_type = Globals.TapeType.SubMachineGun
	self.spray_x = Vector2(-100, 100)
	self.spray_y = Vector2(-50, 50)
	self.cooldown = 5
