extends Node

var dog : Node3D
var herd : Array[Node3D] = []

const FEAR_INDEPENDENCE : float = 3
const FEAR_DISTANCE_FALLOFF : float = 5
const FEAR_MAX_DISTANCE : float = 10

const FEAR_SPEED = 30
const COHESION_SPEED = 10

const COHESION_MIN_DISTANCE : float = 3
const COHESION_MAX_DISTANCE : float = 50

const WALL_AVOIDANCE_RADIUS : float = 2
const WALL_AVOIDANCE_BRAVERY : float = 1

func get_sheep_flight_force(sheep : Node3D) -> Vector3:
	if !dog:
		return Vector3.ZERO

	var straight : Vector3 = (sheep.global_position - dog.global_position)

	var magnitude = straight.length()
	if magnitude > FEAR_MAX_DISTANCE || magnitude <= 0:
		return Vector3.ZERO

	var lookX = dog.global_transform.basis.x
	var lookZ = dog.global_transform.basis.z
	var direction : Vector3 = straight.normalized()

	direction.y = 0

	# crude wall avoidance system
	var space_state := sheep.get_world_3d().direct_space_state
	var wall_params := PhysicsRayQueryParameters3D.create(sheep.global_position, sheep.global_position - direction * WALL_AVOIDANCE_RADIUS)
	var avoidance := Vector3.ZERO
	var sees_wall = space_state.intersect_ray(wall_params)
	if sees_wall:
		avoidance = - lookZ * WALL_AVOIDANCE_BRAVERY # run towards the player because cornered


	#if dog faces sheep, the sheep will veer clockwise or ccw depending on
	#where the dog's gaze is compared to the line of sight to the sheep
	direction = direction * FEAR_INDEPENDENCE - lookZ

	var move_force = direction / pow(magnitude, FEAR_DISTANCE_FALLOFF)

	return (move_force + avoidance).normalized() * FEAR_SPEED


func get_herd_cohesion_force(sheep : Node3D) -> Vector3:
	var sum_force := Vector3.ZERO
	for other in herd:
		if other == sheep:
			continue

		var straight := other.global_position - sheep.global_position
		var magnitude = max(straight.length() - COHESION_MIN_DISTANCE, 0)

		if magnitude <= 0 or magnitude >= COHESION_MAX_DISTANCE:
			continue # too far or too close to care

		#check for linne of sight
		var space_state := other.get_world_3d().direct_space_state
		var wall_sheep_params := PhysicsRayQueryParameters3D.create(sheep.global_position, other.global_position, 2 | 16)
		var sees_sheep_or_wall = space_state.intersect_ray(wall_sheep_params)

		if not sees_sheep_or_wall or sees_sheep_or_wall.collider.collision_layer | 16 != 0:
			continue # we can't see anything interesting in this direction

		# yes, this sheep matters to us
		sum_force += straight.normalized()
	return sum_force * COHESION_SPEED

