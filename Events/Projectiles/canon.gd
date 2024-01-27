extends Node3D

const CanonBall = preload("res://Events/Projectiles/canon_ball.tscn")


func _ready():
	var new_ball = self.CanonBall.instantiate()
	self.add_child(new_ball)

func _on_spawn_timer_timeout():
	var new_ball = self.CanonBall.instantiate()
	self.add_child(new_ball)
