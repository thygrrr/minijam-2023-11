class_name m

static func pow3(basis : Vector3, exponent : float) -> Vector3:
	basis.x = pow(basis.x, exponent)
	basis.y = pow(basis.y, exponent)
	basis.z = pow(basis.z, exponent)
	return basis

static func pow2(basis : Vector2, exponent : float) -> Vector2:
	basis.x = pow(abs(basis.x), exponent) * sign(basis.x)
	basis.y = pow(abs(basis.y), exponent) * sign(basis.y)
	return basis
