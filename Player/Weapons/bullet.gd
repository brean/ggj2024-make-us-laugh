extends CharacterBody3D

const ConfettiParticle = preload("res://Player/Weapons/confetti.tscn")

@export var speed = 15.0

var dir = Vector3.FORWARD

@onready var hitbox = $Hitbox

func _physics_process(_delta):
	self.velocity = self.speed * self.dir 
	self.move_and_slide()

	if self.get_last_slide_collision():
		self.spawn_confetti()
		self.queue_free()


func _on_hitbox_hit_something():
	self.hitbox.knockback_dir = self.dir
	self.spawn_confetti()
	self.queue_free()


func _on_timer_timeout():
	self.spawn_confetti()
	self.queue_free()


func spawn_confetti():
	var new_p = ConfettiParticle.instantiate()
	self.get_parent().add_child(new_p)
	new_p.global_position = self.global_position
