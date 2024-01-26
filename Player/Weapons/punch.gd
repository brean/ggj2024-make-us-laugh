extends "res://Player/Weapons/weapon.gd"

@onready var hitbox = $Hitbox

func _ready():
	self.hitbox.owner_id = self.owner_id
	self.set_hitbox_active(false)
	self.hitbox.connect("hit_something", punched_something)


func use_weapon():
	if not self.on_cooldown:
		self.set_hitbox_active(true)


func _on_cooldown_timer_timeout():
	self.on_cooldown = false


func punched_something():
	self.set_hitbox_active(false)

func set_hitbox_active(active):
	self.hitbox.set_deferred("monitoring", active)
	self.hitbox.set_deferred("monitorable", active)


func update_owner(value):
	self.owner_id = value
	self.hitbox.owner_id = self.owner_id
