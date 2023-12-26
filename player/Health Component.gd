extends Node3D

var player
@onready var respawnTimer = $Timer
@export var decal = Node
var respawn = false
var testDec = 15.0808123131321313
var delta
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	delta = _delta
	print("%2d" % respawnTimer.time_left)
	if player != null:
		if player.currentHealth == 0:
			if respawn == false:
				player.lives -= 1
				#print(player.lives)
				if player.lives > 0:
					respawn = true
					respawnTimer.start()
			if player.lives > 0:
					#player_respawn()
				decal.rotation.y += deg_to_rad(2)
				player.isDead = true
				player.velocity.y = 0
				player.pivot.hide()
				decal.show()
				player.pivot.position.y = 7.5
				player.deathMarker.show()
				player.CollisionShape.disabled = true
				player.deathMarker.position.y = player.Raycast.get_collision_point().y + 1.5
			else:
				Level.players.erase(player)
				player.queue_free()
	pass


func respawn_player():
	player.currentHealth = player.maxHealth
	decal.hide()
	player.pivot.show()
	player.global_position = player.pivot.global_position
	player.pivot.position = Vector3.ZERO
	player.deathMarker.hide()
	player.CollisionShape.disabled = false
	player.isDead = false
	respawn = false
	pass # Replace with function body.
func _input(_event):
	if Input.is_action_just_pressed("player_bottom_action_" + str(player.playerID)) and respawn:
		respawnTimer.stop()
		respawnTimer.emit_signal("timeout")

