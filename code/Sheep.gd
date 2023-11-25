extends RigidBody3D

var dog : Node3D
var mirrored : bool

var move_direction : Vector3 = Vector3.ZERO
@export var move_speed : float = 1

func _physics_process(delta):
	if dog:
		chase_or_flee()
	else:
		move_direction = Vector3.ZERO
	add_constant_central_force(move_direction * move_speed)	
	
	
			
func chase_or_flee():
	var direction : Vector3 = (self.global_position - dog.global_position)
	if mirrored:
		direction *= -1

	move_direction = direction.normalized()
	
func _on_area_3d_body_entered(body):
	if body.name == "Dog Controller":
		dog = body

func _on_area_3d_body_exited(body):
	dog = null
