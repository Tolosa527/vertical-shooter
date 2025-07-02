extends CharacterBody2D
class_name Player

signal player_hit
signal bullet_fired(bullet_position: Vector2, bullet_direction: Vector2)

@export var speed: float = 300.0

var screen_size: Vector2
var can_shoot: bool = true
var shoot_cooldown: float = 0.3

# Animation states
var current_animation_state: String = "idle"
var is_moving_left: bool = false
var is_moving_right: bool = false
var is_shooting: bool = false
var is_taking_damage: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var shoot_timer: Timer = $ShootTimer

func _ready():
	screen_size = get_viewport_rect().size
	
	# Setup shoot timer
	shoot_timer.wait_time = shoot_cooldown
	shoot_timer.one_shot = true
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	
	# Start with idle animation
	play_animation("idle")

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
	is_moving_left = false
	is_moving_right = false
	
	if Input.is_action_pressed("move_left"):
		velocity.x -= speed
		is_moving_left = true
	if Input.is_action_pressed("move_right"):
		velocity.x += speed
		is_moving_right = true
	
	# Update animation based on movement
	update_movement_animation()
	
	move_and_slide()

func update_movement_animation():
	var new_animation = "idle"
	
	# Priority order: damage > shooting > movement > idle
	if is_taking_damage:
		new_animation = "take_damage"
	elif is_shooting:
		new_animation = "shoot"
	elif is_moving_left:
		new_animation = "move_left"
	elif is_moving_right:
		new_animation = "move_right"
	else:
		new_animation = "idle"
	
	if new_animation != current_animation_state:
		play_animation(new_animation)

func play_animation(animation_name: String):
	if animated_sprite.sprite_frames.has_animation(animation_name):
		current_animation_state = animation_name
		animated_sprite.play(animation_name)
	else:
		# Fallback to default if animation doesn't exist
		animated_sprite.play("default")

func handle_shooting():
	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot()

func shoot():
	can_shoot = false
	is_shooting = true
	shoot_timer.start()
	
	# Play shoot animation briefly
	play_animation("shoot")
	
	# Reset to movement animation after short delay
	get_tree().create_timer(0.1).timeout.connect(func():
		is_shooting = false
		update_movement_animation()
	)
	
	# Fire bullet from player position
	var bullet_pos = global_position + Vector2(0, -32)  # Offset to shoot from front
	var bullet_dir = Vector2(0, -1)  # Shoot upward
	
	bullet_fired.emit(bullet_pos, bullet_dir)

func _on_shoot_timer_timeout():
	can_shoot = true

func take_damage():
	player_hit.emit()
	
	# Set damage animation state
	is_taking_damage = true
	play_animation("take_damage")
	
	# Reset damage animation after duration
	get_tree().create_timer(0.5).timeout.connect(func():
		is_taking_damage = false
		update_movement_animation()
	)
	
	# Add visual feedback (flash effect) - optional, since we have animation
	var tween = create_tween()
	tween.tween_property(animated_sprite, "modulate:a", 0.3, 0.1)
	tween.tween_property(animated_sprite, "modulate:a", 1.0, 0.1)

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
