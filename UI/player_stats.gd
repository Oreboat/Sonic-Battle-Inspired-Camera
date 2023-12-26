extends Control

var player
@onready var healthBar = $ProgressBar
@onready var lives = $Label2
@onready var timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player != null:
		healthBar.value = player.currentHealth
		healthBar.max_value = player.maxHealth
		lives.text = "Lives: " + str(player.lives)
		if player.get_node("Health Component").respawn:
			timer.show()
			timer.get_child(1).text = ("%2d" %player.get_node("Health Component").respawnTimer.time_left)
		else:
			timer.hide()
	pass
