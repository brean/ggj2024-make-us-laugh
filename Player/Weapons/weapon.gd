extends Node3D
class_name Weapon

@export var owner_id := -1 
@export var cooldown := 3.0

var on_cooldown := false

func use_weapon():
	pass


func update_owner(value):
	self.onwner_id = value


func _on_cooldown_timer_timeout():
	self.on_cooldown = false
