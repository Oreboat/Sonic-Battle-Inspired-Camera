extends Control

var players = []
@export var defaultSeperation = 250
@export var playerStats : Resource
@onready var StatContainer = $StatContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	var stats = preload("res://src/UI/Scenes/player_stats.tscn")
	StatContainer.add_theme_constant_override("separation", defaultSeperation)
	NodeObject.findNodesOfType(get_parent(),"CharacterBody3D", players)
	for player in players:
		defaultSeperation -= 50
		var pstats = stats.instantiate()
		StatContainer.add_child(pstats)
		pstats.get_node("Label").text = ("Player " + str(player.playerID + 1))
		pstats.player = player
		pass
	StatContainer.add_theme_constant_override("separation", defaultSeperation)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
