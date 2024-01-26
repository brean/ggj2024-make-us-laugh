extends Node
class_name GameMode

signal finished

@export var duration: float

var time_passed: float = 0

func _ready():
	pass

func _process(delta):
	time_passed += delta
	
	if time_passed >= duration:
		timeout()
	
func timeout():
	finished.emit()
	queue_free()
