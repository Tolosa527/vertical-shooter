extends Control

@onready var ship_label = $CenterContainer/VBoxContainer/ShipDisplay/ShipLabel
@onready var player_name_text = $CenterContainer/VBoxContainer/PlayerNameText
@onready var launch_text = $CenterContainer/VBoxContainer/LaunchText
@onready var ship_display = $CenterContainer/VBoxContainer/ShipDisplay

func _ready():
	# Display player info
	if GameData.player_name != "":
		player_name_text.text = "Good luck, Pilot " + GameData.player_name + "!"
	
	if GameData.selected_ship != "":
		ship_label.text = GameData.selected_ship.to_upper()
	
	# Start launch sequence
	start_launch_sequence()

func start_launch_sequence():
	# Phase 1: Ship appears
	ship_display.modulate = Color(1, 1, 1, 0)
	var tween1 = create_tween()
	tween1.tween_property(ship_display, "modulate:a", 1.0, 1.0)
	
	await tween1.finished
	await get_tree().create_timer(1.0).timeout
	
	# Phase 2: Launch text updates
	launch_text.text = "Engines starting..."
	await get_tree().create_timer(1.5).timeout
	
	launch_text.text = "3..."
	await get_tree().create_timer(1.0).timeout
	
	launch_text.text = "2..."
	await get_tree().create_timer(1.0).timeout
	
	launch_text.text = "1..."
	await get_tree().create_timer(1.0).timeout
	
	launch_text.text = "LAUNCH!"
	
	# Phase 3: Ship flies away (simulate movement)
	var tween2 = create_tween()
	tween2.parallel().tween_property(ship_display, "position:y", -300, 2.0)
	tween2.parallel().tween_property(ship_display, "scale", Vector2(0.1, 0.1), 2.0)
	
	await tween2.finished
	
	# Phase 4: Transition to game
	launch_text.text = "Mission begins now!"
	await get_tree().create_timer(1.0).timeout
	
	get_tree().change_scene_to_file("res://scenes/main/Main.tscn")
