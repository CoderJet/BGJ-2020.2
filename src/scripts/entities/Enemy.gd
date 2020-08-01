class_name Enemy
extends Entity

export (PoolVector2Array) var destinations := PoolVector2Array()
var dest_idx = 0

var path = []
var target_point_world = Vector2()
var target_position = Vector2()


func take_damage(damage : int) -> void:
	health -=  damage

	if health <= 0:
		queue_free()


func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		if event.is_pressed() && event.button_mask == BUTTON_MASK_LEFT:
			pass
			#set_destination(get_global_mouse_position())


func set_destination() -> void:
	dest_idx += 1
	dest_idx = dest_idx % destinations.size()

	path = get_node("../../AStar").find_path(position, destinations[dest_idx])
	if not path or len(path) == 1:
		return
	path.remove(0)
	# The index 0 is the starting cell
	# we don't want the character to move back to it in this example
	target_point_world = path[0]



func move_to_destination() -> void:
	if target_point_world == Vector2.ZERO:
		return

	if len(path) == 0:
		return

	if _move_to(target_point_world):
		path.remove(0)
		if len(path) == 0:
			return
		target_point_world = path[0]


func _move_to(world_position):
	var MASS = 10.0
	var ARRIVE_DISTANCE = 10.0

	var desired_velocity = (world_position - position).normalized() * speed
	var steering = desired_velocity - velocity
	velocity += steering / MASS
	position += velocity * get_process_delta_time()
	rotation = velocity.angle()
	return position.distance_to(world_position) < ARRIVE_DISTANCE
