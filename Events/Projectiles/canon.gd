extends Node3D

const CanonBall = preload("res://Events/Projectiles/canon_ball.tscn")

@onready var spawn_timer = $SpawnTimer
@onready var spawn_position = $Center/SpawnPosition

func _ready():
	EventManager.connect("activate_canons", self.activate_canon)

func _on_spawn_timer_timeout():
	var new_ball = self.CanonBall.instantiate()
	new_ball.random_element()
	self.add_child(new_ball)
	new_ball.global_position = self.spawn_position.global_position
	new_ball.linear_velocity = \
		20*self.spawn_position.global_position.direction_to(self.global_position)
	
func activate_canon(set_on):
	if set_on:
		_on_spawn_timer_timeout()
		self.spawn_timer.start(5.0)
	else:
		self.spawn_timer.stop()
