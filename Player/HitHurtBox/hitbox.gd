extends Area3D

var owner_id := -1
@export var knockback_strength := 100

var knockback_dir := Vector3.ZERO

signal hit_something 

func _on_area_entered(area):
	if not area.get_id() == self.owner_id: # should always be a hurtbox
		self.emit_signal("hit_something")
		self.knockback_dir = self.global_position.direction_to(area.global_position)
		area.hit(self.knockback_strength * self.knockback_dir)
