extends RigidBody3D

var elements = [
	[$tomato, $CollisionSphere],
	[$burger, $CollisionSphere],
	[$fridge, $CollisionBox],
]

func disable_all():
	for elem in elements:
		elem[0].disabled = true
		elem[1].disabled = true

func random_element():
	disable_all()
	var this_elem = elements[randi() % elements.size()]
	this_elem[0].disabled = false;
	this_elem[1].disabled = false;

func _on_timer_timeout():
	self.queue_free()
