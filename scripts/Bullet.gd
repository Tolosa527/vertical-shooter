extends Area2D
class_name Bullet

@export var speed: float = 400.0
@export var lifetime: float = 3.0

var direction: Vector2 = Vector2.UP
var screen_size: Vector2

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready():
	screen_size = get_viewport_rect().size
	
	# Add to bullets group for collision detection
	add_to_group("bullets")
	
	# Connect collision detection
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	
	# Auto-destroy after lifetime
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.start()
	timer.timeout.connect(_destroy_bullet)

func _physics_process(delta):
	position += direction * speed * delta
	
	# Destroy bullet if it goes off screen
	if position.y < -32 or position.y > screen_size.y + 32 or \
	   position.x < -32 or position.x > screen_size.x + 32:
		_destroy_bullet()

func _on_area_entered(area):
	# Hit an obstacle or other area
	if area.is_in_group("obstacles"):
		area.take_damage()
		_destroy_bullet()

func _on_body_entered(body):
	# Hit a rigid body obstacle
	if body.is_in_group("obstacles"):
		if body.has_method("take_damage"):
			body.take_damage()
		_destroy_bullet()

func _destroy_bullet():
	# Add small explosion effect
	var tween = create_tween()
	tween.parallel().tween_property(sprite, "scale", Vector2(1.5, 1.5), 0.1)
	tween.parallel().tween_property(sprite, "modulate:a", 0.0, 0.1)
	tween.tween_callback(queue_free)
