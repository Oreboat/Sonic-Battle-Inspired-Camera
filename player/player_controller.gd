extends CharacterBody3D


@export var walk_speed = 5.0
var current_speed
@export var gravity = -9.8
@export var jump_impulse = 2.0
@export var acceleration = 0.0
@export var friction = 3.0
@export var playerID = 0
@export var coyoteTime = 0.2
@export var airFriction = 2
@export var dashSpeed = 15
@export var dashLength = .2

var coyoteTimer = 0
var currentHealth = 100
@export var maxHealth = 100
@export var lives = 3
@export var characterData: fighter
var pivot
var playerText 
@onready var dashTimer = $Timer
@onready var deathMarker = $CSGBox3D
@onready var Raycast = $RayCast3D
@onready var CollisionShape = $CollisionShape3D
var doublejump = true
var maxShieldTimer = 1.5
var currentShieldTimer = 0
var isShielding = false
var isDashing = false
var isDead = false
var dashDirection = Vector3.ZERO
# Get the gravity from the project settings to be synced with RigidBody nodes.

func _ready():
	currentHealth = maxHealth
	loadPlayerData()
	return
	playerText = characterData.get_node("PlayerID")
	playerText.text = "Player " + str(playerID + 1)
func loadPlayerData():
	current_speed = characterData.topSpeed
	acceleration = characterData.acceleration
	friction = characterData.friction
	jump_impulse = characterData.jumpHeight
	print(characterData.characterMesh.get_path())
	#var playerMesh = load(characterData.characterMesh.get_path())
func _process(delta):
	return
	Raycast.position = pivot.position
	if is_on_floor():
		coyoteTimer = coyoteTime
	else:
		coyoteTimer -= delta

func _physics_process(delta):
	return
	var input_vector = Vector3.ZERO
	if isShielding == false:
		input_vector = get_input_vector()
	var direction = get_direction(input_vector)
	if !isDead:
		apply_gravity(delta)
		apply_jump()
	apply_movement(input_vector, direction, delta)
	apply_friction(direction, delta)
	dash(delta, input_vector)
	move_and_slide()
	if Input.is_action_pressed("debug_drain_" + str(playerID)) and currentHealth > 0:
		currentHealth -= 1
	parry(delta)
func apply_friction(direction, delta):
	if direction == Vector3.ZERO and !isDashing:
		if is_on_floor():
			velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
		else:
			velocity.x = velocity.move_toward(direction * current_speed,airFriction * delta).x
			velocity.z = velocity.move_toward(direction * current_speed, airFriction * delta).z
func get_input_vector():
	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("player_right_%s" % [playerID] ) - Input.get_action_strength("player_left_%s" % [playerID])
	input_vector.z = Input.get_action_strength("player_down_%s" % [playerID]) - Input.get_action_strength("player_up_%s" % [playerID])
	return input_vector.normalized() if input_vector.length() > 1 else input_vector
func get_direction(input_vector):
	var direction = (input_vector.x * transform.basis.x) + (input_vector.z * transform.basis.z)
	return direction
func apply_movement(input_vector, direction, delta):
	if input_vector != Vector3.ZERO and !isDashing:
		velocity.x = velocity.move_toward(direction * current_speed, acceleration * delta).x
		velocity.z = velocity.move_toward(direction * current_speed, acceleration * delta).z
		pivot.rotation.y = lerp_angle(pivot.rotation.y,atan2(0,input_vector.x),25 * delta)
func apply_gravity(delta):
	if !isDashing:
		velocity.y += gravity * delta
		velocity.y = clamp(velocity.y, gravity, jump_impulse)
func apply_jump():
	if(Input.is_action_just_pressed("player_jump_%s" % [playerID])):
			if coyoteTimer > 0:
				velocity.y += jump_impulse
				doublejump = true
			elif coyoteTimer <= 0 and doublejump:
				velocity.y += jump_impulse
				doublejump = false
	elif Input.is_action_just_released("player_jump_%s" % [playerID]):
		velocity.y *= .5
func parry(delta):
	if Input.is_action_pressed("player_shield_" + str(playerID)) and is_on_floor():
		if currentShieldTimer > 0:
			currentShieldTimer -= delta
			isShielding = true
		elif currentHealth < maxHealth:
			currentHealth += (delta * 30)
		else:
			isShielding =  false
	else:
		isShielding = false
		currentShieldTimer = maxShieldTimer
func dash(delta, input_vector):
	if Input.is_action_just_pressed("player_shield_" + str(playerID)) and !is_on_floor() and dashDirection == Vector3.ZERO:
		isDashing = true
		dashTimer.wait_time = dashLength
		dashTimer.start()
		dashDirection = get_direction(Vector3(dashInput(input_vector.x),0, dashInput(input_vector.z)))
		velocity.y = 0
	if isDashing:
		velocity.x = velocity.move_toward(dashDirection * dashSpeed, 1).x
		velocity.z = velocity.move_toward(dashDirection * dashSpeed, delta).z
	if Input.is_action_just_released("player_shield_" + str(playerID)) and !is_on_floor() or dashTimer.is_stopped():
		isDashing = false
		dashTimer.stop()
		dashDirection = Vector3.ZERO
func dashInput(InputFloat):
	if InputFloat > 0:
		return 1
	elif InputFloat < 0:
		return -1
	elif InputFloat == 0:
		return 0
