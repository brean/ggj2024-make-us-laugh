extends "res://Events/event.gd"


func activate_event():
	EventManager.emit_signal("activate_tornado", true)
	

func deactivate_event():
	EventManager.emit_signal("activate_tornado", false)
