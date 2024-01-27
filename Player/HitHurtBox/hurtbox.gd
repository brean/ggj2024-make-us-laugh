extends Area3D

const InvTime := 1.0

var player = null

@onready var invisible_timer = $InvisibleTimer

signal got_hit(int)

func get_id():
	return self.player.player_id


func hit(knockback : Vector3, enemy_id):
	var knockback_mod = player.knockback_mod # get knockback modifier from player
	self.player.apply_central_impulse(knockback * knockback_mod)
	self.set_deferred("monitoring", false)
	self.set_deferred("monitorable", false)
	self.invisible_timer.start(self.InvTime)
	self.emit_signal("got_hit", enemy_id)


func _on_invisible_timer_timeout():
	self.set_deferred("monitoring", true)
	self.set_deferred("monitorable", true)
