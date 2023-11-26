extends RigidBody3D
@onready var smoothed_transform : Node3D = $SmoothRemoteTransform3D
@export var flee_speed : float = 50
@export var cohesion_speed : float = 20
@export var idle_speed : float = 10

@export var noise : FastNoiseLite

var move_direction : Vector3 = Vector3.ZERO


signal on_flee;
signal on_chase;
signal on_idle;

var mirrored : bool
var fleeing : bool

var time : float

func _ready():
	var random := RandomNumberGenerator.new()
	time = random.randf_range(0, 100)
	HerdingSystem.herd.push_back(self)

func _physics_process(delta):
	time += delta

	var flee_force := HerdingSystem.get_sheep_flight_force(self)
	var cohesion_force := HerdingSystem.get_herd_cohesion_force(self)

	if flee_force.length_squared() > 0 && !fleeing:
		fleeing = true
		on_flee.emit()

	if flee_force.length_squared() == 0 && fleeing:
		fleeing = false
		on_idle.emit()


	var idle_force := Vector3.ZERO
	idle_force.x += noise.get_noise_2d(time, 3)
	idle_force.z += noise.get_noise_2d(time, 7)

	var combined = cohesion_force * cohesion_speed + flee_force * flee_speed + idle_force * idle_speed
	smoothed_transform.look_at(smoothed_transform.global_position - combined.normalized(), Vector3.UP)
	constant_force = combined
