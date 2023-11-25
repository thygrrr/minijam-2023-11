extends Node3D

@export var target : Node3D
@export var scaling : Vector3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position = scaling * target.global_position
