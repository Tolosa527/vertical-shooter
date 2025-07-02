extends CharacterBody2D
class_name Player

signal player_hit
signal bullet_fired(bullet_position: Vector2, bullet_direction: Vector2)

@export var speed: float = 300.0

var screen_size: Vector2
var can_shoot: bool = true
var shoot_cooldown: float = 0.3

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var shoot_timer: Timer = $ShootTimer

func _ready():
	screen_size = get_viewport_rect().size
	
	# Setup shoot timer
	shoot_timer.wait_time = shoot_cooldown
	shoot_timer.one_shot = true
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func _physics_process(delta):
	handle_movement(delta)
	handle_shooting()
	
	# Check for collisions after movement
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.is_in_group("obstacles"):
			take_damage()
			break
	
	# Keep player within screen bounds
	position.x = clamp(position.x, 32, screen_size.x - 32)
	position.y = clamp(position.y, 32, screen_size.y - 32)

func handle_movement(delta):
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_left"):
		velocity.x -= speed
	if Input.is_action_pressed("move_right"):
		velocity.x += speed
	
	move_and_slide()

func handle_shooting():
	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot()

func shoot():
	can_shoot = false
	shoot_timer.start()
	
	# Fire bullet from player position
	var bullet_pos = global_position + Vector2(0, -32)  # Offset to shoot from front
	var bullet_dir = Vector2(0, -1)  # Shoot upward
	
	bullet_fired.emit(bullet_pos, bullet_dir)

func _on_shoot_timer_timeout():
	can_shoot = true

func take_damage():
	player_hit.emit()
	
	# Add visual feedback (flash effect)
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0.3, 0.1)
	tween.tween_property(sprite, "modulate:a", 1.0, 0.1)

func set_invulnerable(duration: float):
	# Temporary invulnerability after taking damage
	collision_shape.set_deferred("disabled", true)
	
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = duration
	timer.one_shot = true
	timer.start()
	timer.timeout.connect(func(): 
		collision_shape.set_deferred("disabled", false)
		timer.queue_free()
	)
