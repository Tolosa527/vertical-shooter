extends Area2D
class_name Obstacle

signal obstacle_destroyed

@export var health: int = 1
@export var speed: float = 50.0
@export var rotation_speed: float = 1.0
@export var points_value: int = 25

var screen_size: Vector2
var movement_pattern: String = "straight"  # "straight", "zigzag", "spiral"
var time_alive: float = 0.0
var velocity: Vector2 = Vector2.ZERO

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready():
	screen_size = get_viewport_rect().size
	add_to_group("obstacles")
	
	# Connect collision detection
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	
	# Set random movement pattern for higher levels
	var patterns = ["straight", "zigzag"]
	movement_pattern = patterns[randi() % patterns.size()]
	
	# Set initial velocity
	velocity = Vector2(0, speed)

func _physics_process(delta):
	time_alive += delta
	
	# Apply movement pattern
	match movement_pattern:
		"straight":
			velocity = Vector2(0, speed)
		"zigzag":
			var zigzag_offset = sin(time_alive * 3.0) * 30.0
			velocity = Vector2(zigzag_offset, speed)
		"spiral":
			var spiral_x = cos(time_alive * 2.0) * 50.0
			velocity = Vector2(spiral_x, speed)
	
	# Move the obstacle
	position += velocity * delta
	
	# Rotate the asteroid
	rotation += rotation_speed * delta
	
	# Destroy if off screen
	if position.y > screen_size.y + 64:
		queue_free()

func _on_area_entered(area):
	# Handle collision with bullets
	if area.is_in_group("bullets"):
		take_damage()
		area.queue_free()  # Destroy the bullet

func _on_body_entered(body):
	if body is Player:
		# Damage player and destroy obstacle
		body.take_damage()
		destroy_obstacle()

func take_damage():
	health -= 1
	
	# Visual feedback for damage
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color.RED, 0.1)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.1)
	
	if health <= 0:
		destroy_obstacle()

func destroy_obstacle():
	# Add points to score
	var game_manager = get_node("/root/Main/GameManager")
	if game_manager:
		game_manager.add_score(points_value)
	
	obstacle_destroyed.emit()
	
	# Destruction effect
	var tween = create_tween()
	tween.parallel().tween_property(sprite, "scale", Vector2(1.5, 1.5), 0.2)
	tween.parallel().tween_property(sprite, "modulate:a", 0.0, 0.2)
	tween.tween_callback(queue_free)

func set_movement_pattern(pattern: String):
	movement_pattern = pattern

func set_speed(new_speed: float):
	speed = new_speed
