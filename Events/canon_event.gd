extends "res://Events/event.gd"


func activate_event():
	EventManager.emit_signal("activate_canons", true)
	

func deactivate_event():
	EventManager.emit_signal("activate_canons", false)
