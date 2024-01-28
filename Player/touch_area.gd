extends Area3D

var player = null

signal touched_other_player

func _ready():
	self.set_on(false)


func _on_body_entered(body):
	if body.name == "Bar":
		return
	if body.player_id == self.player.player_id:
		return
	self.emit_signal("touched_other_player", self.player.player_id, body.player_id)


func set_on(activate):
	self.set_deferred("monitoring", activate)
	self.set_deferred("monitorable", activate)
