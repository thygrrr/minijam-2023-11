extends CanvasLayer
signal start_game 

# Called when the node enters the scene tree for the first time.
func _ready():
	show_start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func show_message(text):
	%Message.text = text
	%Message.show()
	%MessageTimer.start()

func show_start():
	show_message("It is getting dark.")
	# Wait until the MessageTimer has counted down.

	%Message.text = "Get all sheep to a safe place till the night starts."
	%Message.show()

	%StartButton.show()
	

func update_score(score):
	%ScoreLabel.text = str(score)

	
func show_game_over():
	%Panel.show()
	show_message("Game Over")
	%LevelTimer.stop()
	# Wait until the MessageTimer has counted down.
	await %MessageTimer.timeout

	%Message.text = "It is night and not all Sheep are safe."
	%Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	%StartButton.show()



func _on_start_button_pressed():
		%StartButton.hide()
		%Message.hide()
		%Panel.hide()
		%LevelTimer.start()
		start_game.emit()


func _on_level_timer_timeout():
	show_game_over()


func _on_goal_win():
	%Panel.show()
	show_message("You won!")
	%LevelTimer.stop()
	# Wait until the MessageTimer has counted down.
	await %MessageTimer.timeout

	%Message.text = "All sheeps are safe for the night"
	%Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	%StartButton.show()
