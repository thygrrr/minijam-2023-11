extends Node3D

@onready var anim_player : AnimationPlayer = $AnimationPlayer

func _ready():
	anim_player.play("Anim_Sheep_Idle_Look")


func _on_sheep_on_chase():
	anim_player.play("Anim_Sheep_Chase")


func _on_sheep_on_flee():
	anim_player.play("Anim_Sheep_Run")


func _on_sheep_on_idle():
	anim_player.play("Anim_Sheep_Idle_Food")
