extends Weapon

func _ready():
	self.on_cooldown = false


func use_weapon():
	if not self.on_cooldown:
		self.cooldown_timer.start(self.cooldown)


func _on_cooldown_timer_timeout():
	self.on_cooldown = false

func update_owner(value):
	self.owner_id = value
	self.hitbox.owner_id = self.owner_id
