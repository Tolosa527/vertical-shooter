extends Area2D
class_name Letter

signal letter_collected(letter: String)

@export var letter_value: String = "A"
@export var fall_speed: float = 100.0
@export var float_amplitude: float = 10.0
@export var float_frequency: float = 2.0

var screen_size: Vector2
var time_alive: float = 0.0
var start_position: Vector2

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var label: Label = $Label

func _ready():
	screen_size = get_viewport_rect().size
	start_position = position
	add_to_group("letters")
	
	# Set the letter display
	if label:
		label.text = letter_value
	
	# Connect collision detection
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	time_alive += delta
	
	# Floating movement
	var float_offset = sin(time_alive * float_frequency) * float_amplitude
	position.x = start_position.x + float_offset
	position.y += fall_speed * delta
	
	# Update start position for floating calculation
	start_position.y = position.y
	
	# Destroy if off screen
	if position.y > screen_size.y + 32:
		queue_free()

func _on_area_entered(area):
	if area is Player:
		collect_letter()

func _on_body_entered(body):
	if body is Player:
		collect_letter()

func collect_letter():
	letter_collected.emit(letter_value)
	
	# Collection effect
	var tween = create_tween()
	tween.parallel().tween_property(sprite, "scale", Vector2(1.5, 1.5), 0.2)
	tween.parallel().tween_property(sprite, "modulate:a", 0.0, 0.2)
	tween.parallel().tween_property(self, "position:y", position.y - 50, 0.2)
	tween.tween_callback(queue_free)

func set_letter(new_letter: String):
	letter_value = new_letter
	if label:
		label.text = letter_value
	
	# Change color based on letter (visual variety)
	var colors = [
		Color.CYAN,
		Color.YELLOW,
		Color.MAGENTA,
		Color.GREEN,
		Color.ORANGE
	]
	var color_index = letter_value.unicode_at(0) % colors.size()
	if sprite:
		sprite.modulate = colors[color_index]
