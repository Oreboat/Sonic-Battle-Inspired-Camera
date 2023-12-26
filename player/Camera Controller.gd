extends Node3D

@export var springOffset = 5.0
@onready var springArm = $SpringArm3D
@onready var camera = $Camera3D
@export var CenterPoint = Node3D
@export var clampAngle = 15
@export var camDistance = 5
@export var camera_speed = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	camera.top_level = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Level.players.size() > 1):
		global_position = calculateAveragePosition()
		calculateCameraRotation(delta)
		#if abs(position.x - CenterPoint.position.x) > camDistance:
			#look_at(CenterPoint.position, transform.basis.y)
		rotation = Vector3(0,clamp(-rotation.y,deg_to_rad(-clampAngle),deg_to_rad(clampAngle)),0)
		#camera.position.x = lerp()
		camera.position.z = position.z + 15
		camera.position.x = lerp(camera.position.x, position.x, 10 * delta)
		camera.position.x = clamp(camera.position.x, -camDistance, camDistance)
		camera.size = calculatePlayerDistance() + springOffset
		camera.look_at(global_position, transform.basis.y)
		#calculateCameraLookAt(delta)
		#camera.rotation.y = clamp(-rotation.y,deg_to_rad(-15),deg_to_rad(15))
		springArm.spring_length = global_position.length() + springOffset
		#springArm.get_child(0).look_at(position, Vector3.UP, false)
	else:
		global_position = Level.players[0].global_position
		camera.look_at(global_position, transform.basis.y)
		camera.position.z = position.z + 10
		camera.position.x = lerp(camera.position.x, position.x, 10 * delta)
	pass
func calculateAveragePosition():
	var average = Vector3.ZERO
	if Level.players.size() > 1:
		for player in Level.players:
			average += player.global_position
		return average/Level.players.size()
	else:
		return Level.players[0].global_position
	
func calculatePlayerDistance():
	var maxDistance = 0.0
	for player in Level.players:
		var distance = player.position.distance_to(position)
		if distance > maxDistance:
			maxDistance = distance
	return maxDistance
func calculateCameraRotation(delta):
	var T=global_transform.looking_at(CenterPoint.global_transform.origin, Vector3(0,1,0))
	global_transform.basis.y=lerp(global_transform.basis.y, T.basis.y, delta*camera_speed)
func calculateCameraLookAt(delta):
	var T=global_transform.looking_at(CenterPoint.global_transform.origin, Vector3(0,1,0))
	global_transform.basis.x =lerp(global_transform.basis.x, T.basis.y, delta*camera_speed)
	#global_rotation = lerp_angle(r, angle, 1)
