extends Control

func _ready():
	# Make sure the start button has focus for keyboard navigation
	$VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed():
	# Start the story sequence
	get_tree().change_scene_to_file("res://scenes/story/NameInput.tscn")
