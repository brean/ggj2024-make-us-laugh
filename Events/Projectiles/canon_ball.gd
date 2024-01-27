extends RigidBody3D

var elements = [
	[$tomato, $CollisionSphere],
	[$burger, $CollisionSphere],
	[$fridge, $CollisionBox],
]

func random_element():
	$CollisionSphere.disabled = true
	$CollisionBox.disabled = true
	var this_elem = elements[randi() % elements.size()]
	this_elem[0].visible = true;
	this_elem[1].disabled = false;

func _on_timer_timeout():
	self.queue_free()
