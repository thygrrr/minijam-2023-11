extends Node

var dog : Node3D
var herd : Array[Node3D] = []

const FEAR_INDEPENDENCE : float = 4
const FEAR_DISTANCE_FALLOFF : float = 0.5
const FEAR_MAX_DISTANCE : float = 15

const COHESION_DISTANCE_FALLOFF : float = 0.2
const COHESION_MIN_DISTANCE : float = 3
const COHESION_MAX_DISTANCE : float = 30


func get_sheep_flight_force(sheep : Node3D) -> Vector3:
	if !dog:
		return Vector3.ZERO

	var straight : Vector3 = (sheep.global_position - dog.global_position)

	var magnitude = straight.length()
	if magnitude > FEAR_MAX_DISTANCE || magnitude <= 0:
		return Vector3.ZERO

	var lookZ = dog.global_transform.basis.z
	var direction : Vector3 = straight.normalized()

	#if dog faces sheep, the sheep will veer clockwise or ccw depending on
	#where the dog's gaze is compared to the line of sight to the sheep
	var gaze_strength = max(0, straight.dot(lookZ))
	direction = direction * FEAR_INDEPENDENCE + gaze_strength * direction.reflect(-lookZ)

	direction.y = 0

	var move_force = direction.normalized() / pow(magnitude, FEAR_DISTANCE_FALLOFF)

	return move_force


func get_herd_cohesion_force(sheep : Node3D) -> Vector3:
	var sum_force := Vector3.ZERO
	for other in herd:
		if other == sheep:
			continue
		var space_state := other.get_world_3d().direct_space_state
		var params := PhysicsRayQueryParameters3D.create(sheep.global_position, other.global_position)
		params.collision_mask = 2 + 16  #sheep and walls
		var result = space_state.intersect_ray(params)
		if not result:
			continue # we can't see this other sheep

		var straight := other.global_position - sheep.global_position
		var magnitude = max(straight.length() - COHESION_MIN_DISTANCE, 0)
		if magnitude > 0 and magnitude < COHESION_MAX_DISTANCE:
			sum_force += straight.normalized()
	return sum_force

