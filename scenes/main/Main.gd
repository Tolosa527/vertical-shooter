extends Node2D

@onready var game_manager: GameManager = $GameManager
@onready var background: ScrollingBackground = $ScrollingBackground
@onready var player: Player = $Player
@onready var spawner: Spawner = $Spawner
@onready var ui: UIManager = $UI

var bullet_scene = preload("res://scenes/objects/Bullet.tscn")

func _ready():
	# Connect all systems
	setup_connections()
	
	# Start the game
	start_game()

func setup_connections():
	# Connect player signals
	if player:
		player.player_hit.connect(_on_player_hit)
		player.bullet_fired.connect(_on_bullet_fired)
	
	# Connect game manager to UI
	if ui and game_manager:
		ui.connect_to_game_manager(game_manager)
	
	# Connect spawner to game manager
	if spawner and game_manager:
		spawner.setup_with_game_manager(game_manager)
	
	# Connect game manager signals
	if game_manager:
		game_manager.word_completed.connect(_on_word_completed)
		game_manager.game_over.connect(_on_game_over)
		game_manager.level_changed.connect(_on_level_changed)

func start_game():
	print("Starting Vertical Shooter Educational Game!")
	
	# Show initial instruction
	if ui:
		var instruction = game_manager.get_translation("ui_press_space") if game_manager else "PRESS SPACE TO SHOOT"
		ui.show_instruction(instruction, 3.0)

func _on_player_hit():
	if game_manager:
		game_manager.lose_life()
		
		# Make player temporarily invulnerable
		if player:
			player.set_invulnerable(2.0)

func _on_bullet_fired(bullet_position: Vector2, bullet_direction: Vector2):
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.global_position = bullet_position
	bullet.direction = bullet_direction

func _on_word_completed():
	print("Word completed! Moving to next level...")
	
	# Brief pause before starting next level
	get_tree().create_timer(1.0).timeout.connect(func():
		if spawner:
			spawner.clear_all_spawned_objects()
	)

func _on_game_over():
	print("Game Over!")
	
	# Pause all spawning
	if spawner:
		spawner.pause_spawning()

func _on_level_changed(new_level: int):
	print("Level changed to: ", new_level)
	
	# Update background scroll speed based on level
	if background:
		var new_speed = 50 + (new_level - 1) * 10
		background.set_scroll_speed(new_speed)

func _input(event):
	# Handle restart with R key
	if event.is_action_pressed("ui_accept") and Input.is_key_pressed(KEY_R):
		restart_game()

func restart_game():
	if game_manager:
		game_manager.reset_game()
	
	if spawner:
		spawner.clear_all_spawned_objects()
		spawner.resume_spawning()
	
	print("Game restarted!")
