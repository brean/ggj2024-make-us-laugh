extends "res://Events/event.gd"

const SkeletonDude = preload("res://Events/Enemy/skeleton_warrior.tscn")

@export var spawn_height := 10.0
@export var spawn_range := 10.0

func activate_event():
	var rand_n = randi_range(5, 8)
	for i in range(rand_n):
		var dude = self.SkeletonDude.instantiate()
		self.add_child(dude)
		dude.global_position = self.global_position
		dude.global_position.y = randf_range(-2 , 2) + spawn_height
		dude.global_position.x = randf_range(-1 , 1) * spawn_range
		dude.global_position.z = randf_range(-1 , 1) * spawn_range
		
	
func deactivate_event():
	pass
