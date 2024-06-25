extends CharacterBody3D

const CoinParticle = preload("res://GameMode/Collectables/coin_collect.tscn")


func _physics_process(delta):
	if self.global_position.y < GameManager.ResetHeight:
		self.queue_free()

	if not self.is_on_floor():
		self.velocity.y -= 9.8 * delta
	move_and_slide()


func _on_area_3d_body_entered(body):
	if not body.name.begins_with('Player'):
		return
	GameManager.give_points(body.player_id, 1)
	var particles = self.CoinParticle.instantiate()
	self.get_parent().add_child(particles)
	particles.global_position = self.global_position
	particles.emitting = true
	self.queue_free()
