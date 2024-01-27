extends "res://Events/event.gd"


func activate_event():
	EventManager.emit_signal("activate_bar", true)
	

func deactivate_event():
	EventManager.emit_signal("activate_bar", false)
