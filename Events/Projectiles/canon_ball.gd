extends RigidBody3D

@onready var elements = [
	[$tomato, $CollisionSphere],
	[$burger, $CollisionSphere],
	[$fridge, $CollisionBox],
	[$carrot, $CollisionCylinder],
	[$mustard, $CollisionCylinder],
	[$stew, $CollisionSphere],
]

func random_element():
	var desired = randi() % elements.size()
	var removed_elems = []
	for i in range(elements.size()):
		if i == desired:
			continue
		var this_elem = elements[i]
		for elem in elements[i]:
			if elem in removed_elems:
				continue
			remove_child(elem)
			removed_elems.append(elem)


func _on_timer_timeout():
	self.queue_free()

func _ready():
	random_element()
