extends Node2D
class_name Spawner

signal object_spawned(object: Node2D)

@export var obstacle_scene: PackedScene
@export var letter_scene: PackedScene

var screen_size: Vector2
var game_manager: GameManager

var obstacle_spawn_timer: Timer
var letter_spawn_timer: Timer

var current_obstacles: int = 0
var max_obstacles: int = 3

func _ready():
	screen_size = get_viewport_rect().size
	
	# Create spawn timers
	obstacle_spawn_timer = Timer.new()
	add_child(obstacle_spawn_timer)
	obstacle_spawn_timer.wait_time = 2.0
	obstacle_spawn_timer.timeout.connect(_spawn_obstacle)
	obstacle_spawn_timer.start()
	
	letter_spawn_timer = Timer.new()
	add_child(letter_spawn_timer)
	letter_spawn_timer.wait_time = 3.0
	letter_spawn_timer.timeout.connect(_spawn_letter)
	letter_spawn_timer.start()

func setup_with_game_manager(gm: GameManager):
	game_manager = gm
	if game_manager:
		game_manager.level_changed.connect(_on_level_changed)
		_update_spawn_settings()

func _update_spawn_settings():
	if not game_manager:
		return
	
	var level_settings = game_manager.get_level_settings()
	
	# Update obstacle spawn rate
	var spawn_rate = level_settings.get("obstacle_spawn_rate", 2.0)
	obstacle_spawn_timer.wait_time = spawn_rate
	
	# Update max obstacles
	max_obstacles = level_settings.get("max_obstacles", 3)

func _spawn_obstacle():
	if current_obstacles >= max_obstacles:
		return
	
	if not obstacle_scene:
		print("No obstacle scene assigned to spawner")
		return
	
	var obstacle = obstacle_scene.instantiate()
	if not obstacle:
		print("Failed to instantiate obstacle")
		return
	
	# Position at random X, above screen
	var spawn_x = randf_range(64, screen_size.x - 64)
	obstacle.position = Vector2(spawn_x, -64)
	
	# Set obstacle properties based on level
	if game_manager:
		var level_settings = game_manager.get_level_settings()
		var obstacle_speed = level_settings.get("obstacle_speed", 50)
		obstacle.set_speed(obstacle_speed)
		
		# Set movement pattern for higher levels
		if game_manager.current_level > 2:
			var patterns = ["straight", "zigzag"]
			var pattern = patterns[randi() % patterns.size()]
			obstacle.set_movement_pattern(pattern)
	
	# Connect destruction signal
	obstacle.obstacle_destroyed.connect(_on_obstacle_destroyed)
	
	# Add to scene
	get_parent().add_child(obstacle)
	current_obstacles += 1
	
	object_spawned.emit(obstacle)

func _spawn_letter():
	if not letter_scene:
		print("No letter scene assigned to spawner")
		return
	
	if not game_manager:
		print("No game manager assigned to spawner")
		return
	
	# Get required letters for current word
	var required_letters = []
	var current_word = game_manager.current_word
	for i in range(current_word.length()):
		required_letters.append(current_word[i])
	
	# Choose which letter to spawn
	var letter_to_spawn: String
	
	if game_manager.letters_in_order:
		# Spawn next required letter in sequence
		if game_manager.next_letter_index < required_letters.size():
			letter_to_spawn = required_letters[game_manager.next_letter_index]
		else:
			return  # Word already completed
	else:
		# Spawn random required letter that hasn't been collected
		var available_letters = []
		for letter in required_letters:
			if letter not in game_manager.collected_letters:
				available_letters.append(letter)
		
		if available_letters.is_empty():
			return  # All letters collected
		
		letter_to_spawn = available_letters[randi() % available_letters.size()]
	
	# Create letter instance
	var letter = letter_scene.instantiate()
	if not letter:
		print("Failed to instantiate letter")
		return
	
	# Position at random X, above screen
	var spawn_x = randf_range(64, screen_size.x - 64)
	letter.position = Vector2(spawn_x, -64)
	
	# Set letter value
	letter.set_letter(letter_to_spawn)
	
	# Connect collection signal
	letter.letter_collected.connect(_on_letter_collected)
	
	# Add to scene
	get_parent().add_child(letter)
	
	object_spawned.emit(letter)

func _on_obstacle_destroyed():
	current_obstacles -= 1

func _on_letter_collected(letter: String):
	if game_manager:
		var collected = game_manager.collect_letter(letter)
		if collected:
			print("Collected letter: ", letter)

func _on_level_changed(new_level: int):
	_update_spawn_settings()

func pause_spawning():
	obstacle_spawn_timer.paused = true
	letter_spawn_timer.paused = true

func resume_spawning():
	obstacle_spawn_timer.paused = false
	letter_spawn_timer.paused = false

func clear_all_spawned_objects():
	# Clear all obstacles and letters from scene
	var obstacles = get_tree().get_nodes_in_group("obstacles")
	var letters = get_tree().get_nodes_in_group("letters")
	
	for obstacle in obstacles:
		obstacle.queue_free()
	
	for letter in letters:
		letter.queue_free()
	
	current_obstacles = 0
