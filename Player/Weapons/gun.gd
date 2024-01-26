extends Weapon

const BulletScene = preload("res://Player/Weapons/bullet.tscn")
@onready var marker_3d = $Marker3D

func _ready():
	self.on_cooldown = false


func use_weapon():
	if not self.on_cooldown:
		self.cooldown_timer.start(self.cooldown)
		self.on_cooldown = true
		
		var new_bullet = self.BulletScene.instantiate()
		self.add_child(new_bullet)
		new_bullet.global_position = self.marker_3d.global_position
		var angle = self.global_rotation.y + PI/2.0
		new_bullet.dir = Vector3(-cos(angle), 0.0, sin(angle))
		new_bullet.hitbox.owner_id = self.owner_id
