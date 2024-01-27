extends Node
class_name GameMode

signal finished

@export var display_name: String
@export var duration: float = 5
@export var points_reward: int = 1
@export var points_penalty: int = 1

var time_passed: float = 0

func _ready():
	get_tree().create_timer(duration).timeout.connect(on_timeout)
	
func on_timeout():
	finished.emit()
	queue_free()

func start():
	pass # override for each game mode
