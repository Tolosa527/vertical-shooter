extends Control
class_name UIManager

@onready var score_label: Label = $ScoreLabel
@onready var word_label: Label = $WordLabel
@onready var level_label: Label = $LevelLabel
@onready var lives_label: Label = $LivesLabel
@onready var game_over_panel: Panel = $GameOverPanel
@onready var game_over_label: Label = $GameOverPanel/GameOverLabel
@onready var restart_button: Button = $GameOverPanel/RestartButton
@onready var word_completed_label: Label = $WordCompletedLabel

var game_manager: GameManager

func _ready():
	# Initially hide game over panel and word completed label
	if game_over_panel:
		game_over_panel.visible = false
	if word_completed_label:
		word_completed_label.visible = false
	
	# Setup UI layout
	setup_ui_layout()

func setup_ui_layout():
	# Position UI elements for retro arcade style
	if score_label:
		score_label.position = Vector2(20, 20)
		score_label.add_theme_color_override("font_color", Color.CYAN)
	
	if word_label:
		word_label.position = Vector2(get_viewport().size.x / 2 - 100, 20)
		word_label.add_theme_color_override("font_color", Color.YELLOW)
	
	if level_label:
		level_label.position = Vector2(get_viewport().size.x - 150, 20)
		level_label.add_theme_color_override("font_color", Color.GREEN)
	
	if lives_label:
		lives_label.position = Vector2(20, 50)
		lives_label.add_theme_color_override("font_color", Color.RED)

func connect_to_game_manager(gm: GameManager):
	game_manager = gm
	
	if game_manager:
		game_manager.score_updated.connect(_on_score_updated)
		game_manager.level_changed.connect(_on_level_changed)
		game_manager.word_completed.connect(_on_word_completed)
		game_manager.game_over.connect(_on_game_over)
	
	# Initial UI update
	update_ui()

func update_ui():
	if not game_manager:
		return
	
	update_score(game_manager.score)
	update_word_display()
	update_level(game_manager.current_level)
	update_lives(game_manager.lives)

func update_score(score: int):
	if score_label:
		var score_text = game_manager.get_translation("ui_score") if game_manager else "SCORE:"
		score_label.text = score_text + " " + str(score)

func update_word_display():
	if word_label and game_manager:
		var word_text = game_manager.get_translation("ui_word") if game_manager else "WORD:"
		var word_display = game_manager.get_word_display()
		word_label.text = word_text + " " + word_display

func update_level(level: int):
	if level_label:
		var level_text = game_manager.get_translation("ui_level") if game_manager else "LEVEL:"
		level_label.text = level_text + " " + str(level)

func update_lives(lives: int):
	if lives_label:
		lives_label.text = "LIVES: " + str(lives)

func _on_score_updated(new_score: int):
	update_score(new_score)

func _on_level_changed(new_level: int):
	update_level(new_level)
	update_word_display()

func _on_word_completed():
	if word_completed_label:
		var completed_text = game_manager.get_translation("ui_word_completed") if game_manager else "WORD COMPLETED!"
		word_completed_label.text = completed_text
		word_completed_label.visible = true
		
		# Animate word completed message
		var tween = create_tween()
		tween.tween_property(word_completed_label, "modulate:a", 1.0, 0.2)
		tween.tween_delay(1.5)
		tween.tween_property(word_completed_label, "modulate:a", 0.0, 0.5)
		tween.tween_callback(func(): word_completed_label.visible = false)

func _on_game_over():
	if game_over_panel and game_over_label:
		var game_over_text = game_manager.get_translation("ui_game_over") if game_manager else "GAME OVER"
		game_over_label.text = game_over_text
		game_over_panel.visible = true
		
		# Setup restart button
		if restart_button:
			restart_button.pressed.connect(_on_restart_pressed)

func _on_restart_pressed():
	if game_manager:
		game_manager.reset_game()
	
	if game_over_panel:
		game_over_panel.visible = false
	
	# Disconnect restart button to avoid multiple connections
	if restart_button and restart_button.pressed.is_connected(_on_restart_pressed):
		restart_button.pressed.disconnect(_on_restart_pressed)

func show_instruction(text: String, duration: float = 3.0):
	# Create temporary instruction label
	var instruction_label = Label.new()
	add_child(instruction_label)
	instruction_label.text = text
	instruction_label.position = Vector2(get_viewport().size.x / 2 - 100, get_viewport().size.y - 100)
	instruction_label.add_theme_color_override("font_color", Color.WHITE)
	
	# Fade out after duration
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = duration
	timer.one_shot = true
	timer.start()
	timer.timeout.connect(func():
		instruction_label.queue_free()
		timer.queue_free()
	)
