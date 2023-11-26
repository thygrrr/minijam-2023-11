extends CharacterBody3D

@export var SPEED : float = 8
@export var ACCEL : float = 24

@export var direction := Vector3.ZERO
@export var acceleration := Vector3.ZERO

@export var observer : Camera3D

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	#var v := Vector3.ZERO

	# Polynomial input scaling
	input_dir = m.pow2(input_dir, 0.7)

	# Project observer onto camera plane
	input_dir = input_dir.rotated(-observer.global_rotation.y)

	#input_dir = input_dir * sign(input_dir)
	input_dir *= pow(input_dir.length(), 1.5)

	if input_dir.length_squared() > 1:
		input_dir = input_dir.normalized()

	velocity.x = move_toward(velocity.x, input_dir.x * SPEED, ACCEL * delta)
	velocity.z = move_toward(velocity.z, input_dir.y * SPEED, ACCEL * delta)

	if !is_on_floor():
		velocity.y = move_toward(velocity.y, -9.81, delta)
	else:
		velocity.y = 0

	acceleration = Vector3(input_dir.x, 0, input_dir.y)
	direction = velocity.normalized()

	move_and_slide()
