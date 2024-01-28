extends GameMode

const GunWepaon = preload("res://Player/Weapons/gun.tscn")


var current_guns = []
var mode_active = false


func start():
	self.mode_active = true
	self.current_guns = []
	for player in GameManager.players.values():
		var new_gun = GunWepaon.instantiate()
		player.weapon_hand.add_child(new_gun)
		player.update_weapon()
		self.current_guns.append(new_gun)
		
		player.got_hit.connect(self.on_player_hit)


func on_player_hit(self_id: int, enemy_id: int):
	if self.mode_active:
		GameManager.give_points(self_id, 1)
		GameManager.give_points(enemy_id, -1)


func on_timeout():
	var counter = 0
	self.mode_active = false
	for player in GameManager.players.values():
		player.weapon_hand.call_deferred("remove_child", self.current_guns[counter])
		player.call_deferred("update_weapon")
		self.current_guns[counter].queue_free()
		counter += 1
	
	super.on_timeout()
