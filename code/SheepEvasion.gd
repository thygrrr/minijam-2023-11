extends Node

var dog : Node3D

func _on_rigid_body_3d_body_entered(body):
	dog = body


func _on_rigid_body_3d_body_exited(body):
	dog = null
	
func _process(delta):
	#Move away from dog
	if dog:
		print("want to move away.")
	
