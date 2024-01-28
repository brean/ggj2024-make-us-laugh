extends RigidBody3D

enum States {FALL, CHARGE, RUN}

@export var speed = 500.0
@export var charge_time := 3.0


@onready var ray_cast_3d = $RayCast3D
@onready var animation_player = $AnimationPlayer
@onready var model = $character_skeleton_minion
@onready var charge_timer = $ChargeTimer
@onready var run_trail = $RunTrail

var current_state = States.FALL
var goal_player = null
var run_dir := Vector3.ZERO

func _ready():
	self.animation_player.play("Fall")


func _physics_process(_delta):
	match self.current_state:
		States.FALL:
			if self.global_position.y < GameManager.ResetHeight:
				self.queue_free()
			elif self.ray_cast_3d.is_colliding():
				self.animation_player.play("Idle")
				self.current_state = States.CHARGE
				
				var rand_idx = randi_range(0, len(GameManager.players)-1)
				self.goal_player = GameManager.players[rand_idx]
				self.charge_timer.start(self.charge_time)
		States.CHARGE:
			self.run_dir = \
				self.global_position.direction_to(self.goal_player.global_position)
			var look_direction = Vector2(self.run_dir.x, -self.run_dir.z)
			self.model.rotation.y = lerp_angle(self.model.rotation.y, 
												look_direction.angle() + PI/2.0, 
												0.1)
		States.RUN:
			if not self.ray_cast_3d.is_colliding():
				self.animation_player.play("Fall")
				self.current_state = States.FALL
			if self.linear_velocity.length_squared() < self.speed:
				self.apply_central_impulse(25.0 * self.run_dir)


func _on_charge_timer_timeout():
	run_trail.emitting = true
	self.animation_player.play("Run")
	self.current_state = States.RUN
	self.run_dir.y = 0
