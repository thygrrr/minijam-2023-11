extends RigidBody3D

var dog : Node3D
var mirrored : bool

var move_force : Vector3 = Vector3.ZERO
var move_direction : Vector3 = Vector3.ZERO
@export var move_speed : float = 20
@onready var smoothed_transform : Node3D = $SmoothRemoteTransform3D

func _physics_process(delta):
	if dog:
		chase_or_flee()
	else:
		move_direction = Vector3.ZERO

	smoothed_transform.look_at(smoothed_transform.global_position - move_direction, Vector3.UP)
	constant_force = move_force * move_speed
		
	
			
func chase_or_flee():
	var direction : Vector3 = (self.global_position - dog.global_position)
	if mirrored:
		direction *= -1
	move_direction = direction.normalized()
	var magnitude = direction.length()
	move_force = direction.normalized() / magnitude
	
func _on_area_3d_body_entered(body):
	print("Body entered")

	if body.name == "Dog Controller":
		dog = body

func _on_area_3d_body_exited(body):
	print("Body exited")
	if body.name == "Dog Controller":
		dog = null
