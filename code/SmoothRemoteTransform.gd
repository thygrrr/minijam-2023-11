extends Node3D
class_name SmoothRemoteTransform3D

@export var target  : Node3D;
@export var motion_smooth_time : float = 0.1
@export var angular_smooth_time : float = 0.15

var is_on_character : bool = false
var linear_velocity : Vector3 = Vector3.ZERO
var angular_velocity : Vector3 = Vector3.ZERO

func _ready() -> void:
	is_on_character = get_parent() is CharacterBody3D

func _process(delta: float) -> void:
	if is_on_character:
		follow_rotation_character(delta)
	else:
		follow_rotation(delta)
	follow_position(delta)

func follow_rotation_character(delta: float) -> void:
	var velocity = get_parent().velocity
	var accel = lerp(get_parent().acceleration, velocity, velocity.length()/3.0)

	var rot := LookRotation(target.transform.basis.z, accel, Vector3.UP)
	var current_eulers := target.quaternion.get_euler()

	var goal_eulers := current_eulers + rot.get_euler()
	var soft_accel = clamp(velocity.length()/3.0, 0.2, 1.0)
	var smooth_eulers = SmoothDampEuler(current_eulers, goal_eulers, angular_smooth_time / soft_accel, delta)
	target.quaternion = Quaternion.from_euler(smooth_eulers)

func follow_rotation(delta: float) -> void:
	var current_eulers = global_rotation
	var goal_eulers := target.global_rotation
	var smooth_eulers = SmoothDampEuler(current_eulers, goal_eulers, angular_smooth_time, delta)
	target.quaternion = Quaternion.from_euler(smooth_eulers)

func follow_position(delta: float) -> void:
	var ref_fps = 120
	var exponent = delta * ref_fps
	var k = pow(0.8, exponent)
	target.position = SmoothDamp(target.position, global_position, motion_smooth_time, delta)

func LookRotation(from : Vector3, dir : Vector3, up : Vector3) -> Quaternion:
	if up.cross(dir).is_zero_approx():
		return Quaternion.IDENTITY

	if dir.is_zero_approx():
		return Quaternion.IDENTITY

	var angle = from.signed_angle_to(dir.normalized(), up)
	return Quaternion(up, angle);

func SmoothDamp(current : Vector3, target : Vector3, smoothTime : float, deltaTime : float) -> Vector3:
		if smoothTime == 0:
			return target

		var omega = 2.0 / smoothTime

		var x = omega * deltaTime;
		var exp = 1.0 / (1.0 + x + 0.48 * x * x + 0.235 * x * x * x);

		var change = current - target;
		var originalTo = target;

		# Clamp maxSpeed
		#var maxChange = maxSpeed * smoothTime;
		#change = clamp(change, -maxChange, maxChange);
		target = current - change;

		var temp = (linear_velocity + omega * change) * deltaTime
		linear_velocity = (linear_velocity - omega * temp) * exp
		var output = target + (change + temp) * exp

		# Prevent overshooting - FIXME - probably needs to treat all components separately.
		if (originalTo.x > current.x) == (output.x > originalTo.x):
			output.x = originalTo.x
			linear_velocity.x = (output.x - originalTo.x) / deltaTime
		if (originalTo.y > current.y) == (output.y > originalTo.y):
			output.y = originalTo.y
			linear_velocity.y = (output.y - originalTo.y) / deltaTime
		if (originalTo.z > current.z) == (output.z > originalTo.z):
			output.z = originalTo.z
			linear_velocity.z = (output.z - originalTo.z) / deltaTime

		return output;


func SmoothDampEuler(current : Vector3, target : Vector3, smoothTime : float, deltaTime : float) -> Vector3:
		if smoothTime == 0:
			return target

		var omega = 2.0 / smoothTime

		var x = omega * deltaTime;
		var exp = 1.0 / (1.0 + x + 0.48 * x * x + 0.235 * x * x * x);

		var change = current - target;
		var originalTo = target;

		# Clamp maxSpeed
		#var maxChange = maxSpeed * smoothTime;
		#change = clamp(change, -maxChange, maxChange);
		target = current - change;

		var temp = (angular_velocity + omega * change) * deltaTime
		angular_velocity = (angular_velocity - omega * temp) * exp
		var output = target + (change + temp) * exp

		# Prevent overshooting - FIXME - probably needs to treat all components separately.

		#if (originalTo.x > current.x) == (output.x > originalTo.x):
		#	output.x = originalTo.x
		#	angular_velocity.x = (output.x - originalTo.x) / deltaTime
		#if (originalTo.y > current.y) == (output.y > originalTo.y):
		#	output.y = originalTo.y
		#	angular_velocity.y = (output.y - originalTo.y) / deltaTime
		#if (originalTo.z > current.z) == (output.z > originalTo.z):
		#output.z = originalTo.z
		#	angular_velocity.z = (output.z - originalTo.z) / deltaTime

		return output;

