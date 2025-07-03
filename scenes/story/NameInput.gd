extends Control

@onready var name_input = $CenterContainer/LeftPanel/LeftPanelBackground/InputContainer/InputSection/NameInputField
@onready var confirm_button = $CenterContainer/LeftPanel/LeftPanelBackground/InputContainer/ConfirmButton
@onready var dialogue_label = $CenterContainer/LeftPanel/LeftPanelBackground/InputContainer/DialogueLabel

var player_name: String = ""
var input_validated = false

func _ready():
	name_input.grab_focus()
	name_input.text_submitted.connect(_on_name_submitted)
	
	# Add typing sound effect simulation
	name_input.text_changed.connect(_on_text_changed)

func _on_text_changed(new_text: String):
	# Simple validation feedback
	if new_text.length() > 0:
		confirm_button.modulate = Color(1, 1, 1, 1)
	else:
		confirm_button.modulate = Color(0.5, 0.5, 0.5, 1)

func _on_confirm_button_pressed():
	_submit_name()

func _on_name_submitted(text: String = ""):
	_submit_name()

func _submit_name():
	player_name = name_input.text.strip_edges()
	
	if player_name.length() > 0:
		if not input_validated:
			input_validated = true
			# Store the player name globally
			GameData.player_name = player_name
			
			# Show military confirmation
			dialogue_label.text = "[center][color=green]◄ REGISTRATION CONFIRMED ►[/color]

[color=white]Welcome to the unit, soldier [color=yellow]" + player_name.to_upper() + "[/color]![/color]

[color=cyan]Preparing mission briefing...[/color][/center]"
			
			confirm_button.text = "◄ ACCESSING BRIEFING... ►"
			confirm_button.disabled = true
			name_input.editable = false
			
			# Military-style transition delay
			await get_tree().create_timer(2.5).timeout
			get_tree().change_scene_to_file("res://scenes/story/MissionBriefing.tscn")
	else:
		# Show error with military styling
		dialogue_label.text = "[center][color=red]◄ ERROR: INVALID INPUT ►[/color]

[color=white]Soldier identification required! Please state your name clearly.[/color][/center]"
		
		# Flash the input field
		var tween = create_tween()
		tween.tween_property(name_input, "modulate", Color(1, 0.5, 0.5, 1), 0.1)
		tween.tween_property(name_input, "modulate", Color(1, 1, 1, 1), 0.1)
