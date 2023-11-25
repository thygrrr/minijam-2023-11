extends Node

var dog : Node3D
	
func _process(delta):
	#Move away from dog
	if dog:
		print("want to move away.")
	

func _on_area_3d_body_entered(body):
	if body.name == "Dog Controller":
		dog = body


func _on_area_3d_area_exited(area):
	dog = null
