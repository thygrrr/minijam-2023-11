extends Node

var main_loop = preload("res://sheep-herding-loop.wav")
var mirror_loop = preload("res://mirror-world.WAV")

# Called when the node enters the scene tree for the first time.
func _ready():
	$MainLoop.play(main_loop)

func on_mirror_enter():
	$MainLoop.stream = mirror_loop
	$MainLoop.play()
	
func on_mirror_exit():
	$MainLoop.stream = main_loop
	$MainLoop.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
