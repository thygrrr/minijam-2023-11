extends RigidBody3D

var dog : Node3D
var mirrored : bool
@export var distance_scale := 0.5
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

func _ready():
	var random := RandomNumberGenerator.new()
	time = random.randf_range(0, 100)
	
func _physics_process(delta):
	if dog:
		chase_or_flee()
	else:
		move_direction = Vector3.ZERO

	time += delta
	
	var move_noise : Vector3
	move_noise.x += noise.get_noise_2d(time, 3)
	move_noise.z += noise.get_noise_2d(time, 7) 
	
			
	var combined = move_force * move_speed + move_noise * noise_speed 
	smoothed_transform.look_at(smoothed_transform.global_position - combined, Vector3.UP)
	constant_force = combined
	
			
func chase_or_flee():
	var direction : Vector3 = ($SheepArea.global_position - dog.global_position)
	if mirrored:
		on_chase.emit()
		direction *= -1
	else:
		on_flee.emit()
	direction.y = 0
	move_direction = direction.normalized()
	var magnitude = direction.length()
	move_force = direction.normalized() * pow(1.0 / magnitude, distance_scale)
	
func _on_area_3d_body_entered(body):
	if body.name == "Dog Controller":
		dog = body

func _on_area_3d_body_exited(body):
	if body.name == "Dog Controller":
		on_idle.emit()
		dog = null

