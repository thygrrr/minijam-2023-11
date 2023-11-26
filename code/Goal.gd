extends Node3D
@export var sheep_count_goal : int = 1
var sheep_count : int
signal win
# Called when the node enters the scene tree for the first time.
func _ready():
	sheep_count = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_area_entered(area):
	print(sheep_count)
	if area.name == "Sheep Area":
		sheep_count += 1
		if sheep_count >= sheep_count_goal:
			win.emit()


func _on_area_3d_area_exited(area):
	pass
	#sheep_count -= 1
