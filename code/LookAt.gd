extends Camera3D

@export var target : Node3D

@onready var noise = FastNoiseLite.new()
@onready var shake = FastNoiseLite.new()

var acceleration_offset := Vector3(0, 0, 0)
var time : float = 0

func _ready() -> void:
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.02
	shake.noise_type = FastNoiseLite.TYPE_PERLIN
	shake.frequency = 0.03
	shake.domain_warp_enabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	var noise_pos = Vector3(noise.get_noise_2d(1, time)*3, noise.get_noise_2d(5, time)*1, noise.get_noise_2d(10, time)*1)
	global_transform = global_transform.looking_at(target.global_position + noise_pos)
	noise_pos = Vector3(noise.get_noise_2d(3, time*2)*1, noise.get_noise_2d(1, time)*2, noise.get_noise_2d(7, time)*1)

	position = noise_pos + acceleration_offset

