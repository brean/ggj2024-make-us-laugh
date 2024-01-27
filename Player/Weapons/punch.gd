extends "res://Player/Weapons/weapon.gd"

const attack_time := 0.5

@onready var hitbox = $Hitbox
@onready var attack_timer = $AttackTimer


func _ready():
	self.on_cooldown = false
	$MeshInstance3D.visible = false
	self.hitbox.owner_id = self.owner_id
	self.set_hitbox_active(false)
	self.hitbox.connect("hit_something", punched_something)


func use_weapon():
	if not self.on_cooldown and not self.attack_timer.time_left > 0:
		self.set_hitbox_active(true)
		$MeshInstance3D.visible = true
		self.attack_timer.start(self.attack_time)
		self.on_cooldown = true


func _on_cooldown_timer_timeout():
	self.on_cooldown = false


func punched_something():
	self.attack_timer.stop()
	self.go_to_cooldown()


func set_hitbox_active(active):
	self.hitbox.set_deferred("monitoring", active)
	self.hitbox.set_deferred("monitorable", active)


func update_owner(value):
	self.owner_id = value
	self.hitbox.owner_id = self.owner_id


func go_to_cooldown():
	self.set_hitbox_active(false)
	self.on_cooldown = true
	$MeshInstance3D.visible = false
	self.cooldown_timer.start(self.cooldown)


func _on_attack_timer_timeout():
	self.go_to_cooldown()
