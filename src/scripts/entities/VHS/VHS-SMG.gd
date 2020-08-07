extends VHS_Data

func _init() -> void:
	self.tape_type = Globals.TapeType.SubMachineGun
	self.spray_x = Vector2(-100, 100)
	self.spray_y = Vector2(-50, 50)
	self.gun_damage = 2
	self.max_magazine_size = 25
	self.magazine_size = self.max_magazine_size
	self.shot_delay = 0.05
	self.reload_delay = 0.15
	self.audio_clip = "VCR SFX_Fire_SMG.wav"
	self.image = "res://assets/UI/UI_WEAPON_SMG.png"
