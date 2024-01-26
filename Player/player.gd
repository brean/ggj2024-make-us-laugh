extends RigidBody3D

const OriginalSpeed := 5.0
const OriginalAcc := 12.0
const OriginalJumpImpulse := 250.0
const RotationSpeed := 0.2

@export var player_id := 0

@export var max_speed := self.OriginalSpeed
@export var acceleration := self.OriginalAcc
@export var jump_impulse := self.OriginalJumpImpulse

var direction := Vector2.ZERO

@onready var model = $ModelNode
@onready var ground_cast = $GroundCast

func _physics_process(delta):
	# Get input
	self.direction.x = - MultiplayerInput.get_action_strength(self.player_id, "Left") \
						+ MultiplayerInput.get_action_strength(self.player_id, "Right")
	self.direction.y = - MultiplayerInput.get_action_strength(self.player_id, "Forward") \
						+ MultiplayerInput.get_action_strength(self.player_id, "Backward")

	# Add impuls if not to fast
	var horizontal_velocity = Vector2(self.linear_velocity.x, self.linear_velocity.z)
	if horizontal_velocity.length() < self.max_speed:
		self.direction = self.direction.normalized()
		self.apply_central_impulse(acceleration * Vector3(self.direction.x, 0.0, self.direction.y))
	
	# Jump
	if MultiplayerInput.is_action_just_pressed(self.player_id, "Jump"):
		self.ground_cast.force_raycast_update()
		if self.ground_cast.is_colliding():
			self.apply_central_impulse(jump_impulse * Vector3(0.0, 1.0, 0.0))

	# Rotate model
	self.rotate_model()

func rotate_model():
	var look_direction = Vector2(self.linear_velocity.x, -self.linear_velocity.z)
	if not look_direction == Vector2.ZERO:
		self.model.rotation.y = lerp_angle(self.model.rotation.y, look_direction.angle() + PI/2.0, 
											self.RotationSpeed)

