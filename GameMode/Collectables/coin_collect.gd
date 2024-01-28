extends GPUParticles3D


func _on_finished():
	self.queue_free()
