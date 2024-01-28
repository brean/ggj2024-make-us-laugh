extends GameMode

const ProtectTime = 1.0

var currently_touched_idx := []
var mode_is_active = false
var first_time = true

@onready var protect_timer = $ProtectTimer


func start():
	if GameManager.current_max == 0:
		self.on_timeout()
		return
	self.currently_touched_idx = []
	# activate areas
	for player in GameManager.players.values():
		player.touch_area.set_on(true)
		if self.first_time:
			player.touch_area.connect("touched_other_player", self.players_touched)
	
	self.protect_timer.start(self.ProtectTime)
	self.mode_is_active = true
	self.first_time = false
	
func players_touched(self_id: int, enemy_id: int):
	if self.mode_is_active:
		if (self.currently_touched_idx.has(self_id) or 
			self.currently_touched_idx.has(enemy_id)) :
				return

		self.currently_touched_idx.append(self_id)
		self.currently_touched_idx.append(enemy_id)

		var old_points_self = GameManager.points_per_player[self_id]
		var old_points_enemy = GameManager.points_per_player[enemy_id]

		GameManager.points_per_player[self_id] = old_points_enemy
		GameManager.points_per_player[enemy_id] = old_points_self

		GameManager.emit_signal("points_updated", self_id, old_points_enemy)
		GameManager.emit_signal("points_updated", enemy_id, old_points_self)

func on_timeout():
	# deaativate areas
	for player in GameManager.players.values():
		player.touch_area.set_on(false)
	self.protect_timer.stop()
	self.mode_is_active = false
	super.on_timeout()


func _on_protect_timer_timeout():
	self.currently_touched_idx = [] # reset protection
