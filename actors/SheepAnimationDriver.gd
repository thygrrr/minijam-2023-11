extends Node3D

@onready var anim_player : AnimationPlayer = $AnimationPlayer

func _ready():
	anim_player.play("Anim_Sheep_Idle_Look")
