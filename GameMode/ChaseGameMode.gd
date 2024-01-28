extends GameMode

const HunterImage = preload("res://GameMode/Images/Hunter.png")
const GunWepaon = preload("res://Player/Weapons/gun.tscn")


@export var catch_reward: int = 1
@export var survival_reward: int = 2
@export var chasing_speed_boost: float = 1.3

var chasing_player_id: int
var chased_player_ids: Array = []
var caught_player_ids: Array = []

var current_gun = null

func start():
	chasing_player_id = GameManager.players.keys().pick_random()
	chased_player_ids = Array(GameManager.players.keys())
	chased_player_ids.erase(chasing_player_id)
	for player_id in chased_player_ids:
		GameManager.players[player_id].got_hit.connect(on_chased_player_touched)
	
	var chasing_player = GameManager.players[chasing_player_id]
	chasing_player.max_speed *= chasing_speed_boost
	chasing_player.acceleration *= chasing_speed_boost
	
	self.current_gun = GunWepaon.instantiate()
	chasing_player.weapon_hand.add_child(self.current_gun)
	chasing_player.update_weapon()
	
	chasing_player.game_symbol.visible = true
	chasing_player.game_symbol.texture = self.HunterImage
	
func on_chased_player_touched(self_id: int, enemy_id: int):
	if not self_id in caught_player_ids and enemy_id == chasing_player_id:
		# player caught
		caught_player_ids.append(self_id)
		GameManager.give_points(chasing_player_id, catch_reward)
	
	var chase_over = true
	for id in chased_player_ids:
		if id not in caught_player_ids:
			chase_over = false
			break
			
	if chase_over: on_timeout()

func on_timeout():
	for player_id in chased_player_ids:
		if player_id not in caught_player_ids:
			GameManager.give_points(player_id, survival_reward)
	
	var chasing_player = GameManager.players[chasing_player_id]
	chasing_player.reset_modifiers()
	chasing_player.game_symbol.visible = false
	chasing_player.weapon_hand.call_deferred("remove_child", self.current_gun)
	chasing_player.call_deferred("update_weapon")
	self.current_gun.queue_free()
	
	super.on_timeout()
