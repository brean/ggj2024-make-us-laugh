extends CharacterBody3D

@export var speed = 15.0

var dir = Vector3.FORWARD

@onready var hitbox = $Hitbox

func _physics_process(delta):
	self.velocity = self.speed * self.dir 
	self.move_and_slide()

	if self.get_last_slide_collision():
		self.queue_free()


func _on_hitbox_hit_something():
	self.hitbox.knockback_dir = self.dir
	self.queue_free()


func _on_timer_timeout():
	self.queue_free()
