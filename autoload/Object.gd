extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


func findNodesOfType(node: Node, className: String, result: Array):
	if node.is_class(className):
		result.push_back(node)
		print(node.name + " has " + className)
	for child in node.get_children():
		findNodesOfType(child, className, result)
func lerpPos(lerpPosition: Vector3, lerpSpeed: float, delta: float, lerpObject: Node3D):
	lerp(lerpObject.global_position, lerpPosition, lerpSpeed * delta)
	pass
func approxLerp():
	pass
