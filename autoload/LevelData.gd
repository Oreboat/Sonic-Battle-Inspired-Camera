extends Node

var players = []
# Called when the node enters the scene tree for the first time.
func _ready():
	NodeObject.findNodesOfType(get_parent(), "CharacterBody3D", players)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
