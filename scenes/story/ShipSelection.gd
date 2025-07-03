extends Control

@onready var selected_label = $VBoxContainer/SelectedLabel

func _on_ship_selected(ship_type: String):
	# Store the selected ship
	GameData.selected_ship = ship_type
	
	# Update the label
	selected_label.text = "You selected: " + ship_type + "! Launching in 3 seconds..."
	
	# Disable all buttons
	var buttons = get_tree().get_nodes_in_group("ship_buttons")
	for button in buttons:
		if button is Button:
			button.disabled = true
	
	# Wait then transition to launch scene
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://scenes/story/Launch.tscn")
