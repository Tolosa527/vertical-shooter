extends Control

@onready var player_name_label = $HBoxContainer/DialogueSide/PlayerNameLabel
@onready var subtitle_label = $HBoxContainer/DialogueSide/SubtitlePanel/SubtitleLabel
@onready var audio_player = $HBoxContainer/GeneralSide/AudioControls/AudioPlayer
@onready var play_button = $HBoxContainer/GeneralSide/AudioControls/PlayButton
@onready var continue_button = $HBoxContainer/DialogueSide/ContinueButton

# Mission briefing text (you'll replace this with actual audio sync)
var briefing_lines = [
	"Pilot, we have a critical situation in the outer sectors.",
	"Alien artifacts containing ancient words have been scattered across space.",
	"These words hold the key to activating our defense systems.",
	"Your mission is to collect these letter fragments and form complete words.",
	"But beware - hostile obstacles patrol those sectors.",
	"Use your weapons to clear the path, but your primary objective is the letters.",
	"The fate of our galaxy depends on your success, pilot.",
	"Are you ready for this mission?"
]

var current_line = 0
var briefing_active = false

func _ready():
	if GameData.player_name != "":
		player_name_label.text = "Pilot: " + GameData.player_name

func _on_play_button_pressed():
	if not briefing_active:
		start_briefing()

func start_briefing():
	briefing_active = true
	play_button.disabled = true
	current_line = 0
	show_next_line()

func show_next_line():
	if current_line < briefing_lines.size():
		subtitle_label.text = briefing_lines[current_line]
		current_line += 1
		
		# Wait 3 seconds then show next line (you can sync this with actual audio)
		await get_tree().create_timer(3.0).timeout
		show_next_line()
	else:
		finish_briefing()

func finish_briefing():
	subtitle_label.text = "Mission briefing complete. Good luck, pilot!"
	continue_button.disabled = false
	play_button.text = "BRIEFING COMPLETE"

func _on_continue_button_pressed():
	get_tree().change_scene_to_file("res://scenes/story/ShipSelection.tscn")
