extends RigidBody3D
@onready var smoothed_transform : Node3D = $SmoothRemoteTransform3D
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


	var idle_force := Vector3(idle_speed, 0, idle_speed)
	idle_force.x *= noise.get_noise_2d(time, 3) #prime numbers to get a nice interleaved wobble left/right/up/down
	idle_force.z *= noise.get_noise_2d(time, 7)


	var combined = cohesion_force + flee_force + idle_force
	smoothed_transform.look_at(smoothed_transform.global_position - combined.normalized(), Vector3.UP)
	constant_force = combined
