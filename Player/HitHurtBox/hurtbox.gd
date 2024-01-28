extends Area3D

const InvTime := 0.3

var player = null

@onready var invisible_timer = $InvisibleTimer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $HurtSound

signal got_hit(int)

func get_id():
	return self.player.player_id


func hit(knockback : Vector3, enemy_id):
	var knockback_mod = player.knockback_mod # get knockback modifier from player
	self.player.apply_central_impulse(knockback * knockback_mod)
	self.set_deferred("monitoring", false)
	self.set_deferred("monitorable", false)
	self.invisible_timer.start(self.InvTime)
	self.audio_stream_player_3d.play()
	self.emit_signal("got_hit", enemy_id)


func _on_invisible_timer_timeout():
	self.set_deferred("monitoring", true)
	self.set_deferred("monitorable", true)
