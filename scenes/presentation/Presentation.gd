extends Control

@onready var intro_texts = [
	$CenterContainer/VBoxContainer/IntroText1,
	$CenterContainer/VBoxContainer/IntroText2,
	$CenterContainer/VBoxContainer/IntroText3,
	$CenterContainer/VBoxContainer/IntroText4,
	$CenterContainer/VBoxContainer/IntroText5
]
@onready var timer = $Timer

var current_text_index = 0
var presentation_complete = false

func _ready():
	timer.timeout.connect(_on_timer_timeout)
	show_next_text()

func _input(event):
	# Allow skipping with space key
	if event.is_action_pressed("ui_accept") or (event is InputEventKey and event.keycode == KEY_SPACE):
		skip_presentation()

func show_next_text():
	if current_text_index < intro_texts.size():
		var text_label = intro_texts[current_text_index]
		
		# Create a fade-in tween
		var tween = create_tween()
		tween.tween_property(text_label, "modulate:a", 1.0, 1.0)
		
		current_text_index += 1
		timer.start()
	else:
		complete_presentation()

func _on_timer_timeout():
	if current_text_index < intro_texts.size():
		show_next_text()
	else:
		# Wait a bit longer before auto-transitioning
		timer.wait_time = 3.0
		timer.timeout.disconnect(_on_timer_timeout)
		timer.timeout.connect(complete_presentation)
		timer.start()

func skip_presentation():
	if not presentation_complete:
		complete_presentation()

func complete_presentation():
	if presentation_complete:
		return
	
	presentation_complete = true
	
	# Fade out and transition to game
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	tween.tween_callback(start_game)

func start_game():
	get_tree().change_scene_to_file("res://scenes/main/Main.tscn")
