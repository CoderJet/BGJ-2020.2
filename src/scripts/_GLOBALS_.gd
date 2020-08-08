extends Node

enum TapeType  {
	Pistol = 0,
	SubMachineGun
}

var player = null
var sfx_players = {}

func _ready():
	print("test_ready")

func _play_song(song_name : String, vol : float = -5, bus : String = "Master") -> void:
	var path = "res://assets/audio/music/%s" % [song_name]

	if !player:
		player = AudioStreamPlayer.new()
		get_node("/root/Globals").add_child(player)
		player.volume_db = vol

	var audio = load(path)
	if !audio:
		print("Resource ", path, " was unable to be loaded!")
		return

	player.stream = audio
	player.bus = bus
	player.play()

func _play_clip(sfx_name : String, bus : String = "Master") -> void:
	var path = "res://assets/audio/sfx/%s" % [sfx_name]

	var sfx_player = null
	if sfx_players.has(sfx_name) == false:
		sfx_player = AudioStreamPlayer.new()
		get_node("/root/Globals").add_child(sfx_player)
		sfx_players[sfx_name] = sfx_player
	else:
		sfx_player = sfx_players[sfx_name]

	var audio = load(path)
	if !audio:
		print("Resource ", path, " was unable to be loaded!")
		return

	sfx_player.stream = audio
	sfx_player.play()

func _stop_clip(sfx_name : String) -> void:
	if sfx_players.has(sfx_name):
		sfx_players[sfx_name].stop()

#==================================================
# SmoothLookAt Function
#==================================================
#    SmoothLookAtRigid -> Call from integrate_forces()
#    SmoothLookAt for KinematicBody2D -> Call from _physics_process()
#    SmoothLookAt for Node2D -> Call from _process()
#    ----------
#    nodeToTurn = the node you want to turn
#    targetPosition = the Vector2 you want your nodeToTurn to face
#    turnSpeed = how quickly nodeToTurn will turn to face the direction you want it to face
#    ----------
#    X+ is assumed to be forward, the face/nose of your object

func SmoothLookAt( nodeToTurn, targetPosition, turnSpeed):
	nodeToTurn.rotate( deg2rad( AngularLookAt( nodeToTurn.global_position, nodeToTurn.global_rotation, targetPosition, turnSpeed ) ) )
func SmoothLookAtRigid( nodeToTurn, targetPosition, turnSpeed):
	nodeToTurn.angular_velocity = AngularLookAt( nodeToTurn.global_position, nodeToTurn.global_rotation, targetPosition, turnSpeed )

#-------------------------
# these are only called from above functions
func AngularLookAt( currentPosition, currentRotation, targetPosition, turnTime ):
	return GetAngle( currentRotation, TargetAngle( currentPosition, targetPosition ) )/turnTime
func TargetAngle( currentPosition, targetPosition ):
	return (targetPosition - currentPosition).angle()
func GetAngle( currentAngle, targetAngle ):
	return fposmod( targetAngle - currentAngle + PI, PI * 2 ) - PI
