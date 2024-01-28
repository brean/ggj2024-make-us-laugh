extends "res://Events/event.gd"

@export var amount: int = 20

var banana_scene = preload("res://Events/NatureObstacles/banana.tscn")

func activate_event():
	for i in amount:
		var pos = Vector3i(randf_range(-30.0, 30.0), 10, randf_range(-30.0, 30.0))
		var instance: Node3D = banana_scene.instantiate()
		instance.rotation.y = randfn(0, PI * 2)
		instance.position = pos
		add_child(instance)
	
func deactivate_event():
	pass
