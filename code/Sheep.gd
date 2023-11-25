extends RigidBody3D

var dog : Node3D
var mirrored : bool

var move_force : Vector3 = Vector3.ZERO
var move_direction : Vector3 = Vector3.ZERO
@export var move_speed : float = 100
@export var noise_speed : float = 20
@onready var smoothed_transform : Node3D = $SmoothRemoteTransform3D

@export var noise : FastNoiseLite

signal on_flee;
signal on_chase;
signal on_idle;

var time : float
func _physics_process(delta):
	if dog:
		chase_or_flee()
		smoothed_transform.look_at(smoothed_transform.global_position - move_direction, Vector3.UP)
	else:
		move_direction = Vector3.ZERO

	time += delta
	var move_noise : Vector3
	move_noise.x += noise.get_noise_2d(time, 3) - 0.5
	move_noise.z += noise.get_noise_2d(time, 7) - 0.5
	
			
	var combined = move_force * move_speed 
	combined += move_noise * noise_speed
	constant_force = combined
	
			
func chase_or_flee():
	var direction : Vector3 = (self.global_position - dog.global_position)
	if mirrored:
		on_chase.emit()
		direction *= -1
	else:
		on_flee.emit()
	direction.y = 0
	move_direction = direction.normalized()
	var magnitude = direction.length()
	move_force = direction.normalized() / magnitude
	
func _on_area_3d_body_entered(body):
	if body.name == "Dog Controller":
		dog = body

func _on_area_3d_body_exited(body):
	if body.name == "Dog Controller":
		on_idle.emit()
		dog = null

