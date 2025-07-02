extends Node2D
class_name ScrollingBackground

@export var scroll_speed: float = 50.0
@export var star_count: int = 100
@export var star_layers: int = 3

var screen_size: Vector2
var stars: Array[Array] = []

func _ready():
	screen_size = get_viewport_rect().size
	generate_stars()

func generate_stars():
	# Create multiple layers of stars for parallax effect
	for layer in range(star_layers):
		var layer_stars = []
		var layer_speed = scroll_speed * (layer + 1) * 0.3
		var star_size = 1.0 + layer * 0.5
		
		for i in range(star_count / star_layers):
			var star = {
				"position": Vector2(
					randf() * screen_size.x,
					randf() * screen_size.y
				),
				"speed": layer_speed,
				"size": star_size,
				"brightness": 0.3 + layer * 0.3
			}
			layer_stars.append(star)
		
		stars.append(layer_stars)

func _draw():
	# Draw all star layers
	for layer_index in range(stars.size()):
		var layer_stars = stars[layer_index]
		var brightness = 0.3 + layer_index * 0.3
		var color = Color(brightness, brightness, brightness, 1.0)
		
		for star in layer_stars:
			var size = star.size
			draw_circle(star.position, size, color)

func _process(delta):
	# Move stars down
	for layer_stars in stars:
		for star in layer_stars:
			star.position.y += star.speed * delta
			
			# Wrap around when star goes off screen
			if star.position.y > screen_size.y + 10:
				star.position.y = -10
				star.position.x = randf() * screen_size.x
	
	# Redraw stars
	queue_redraw()

func set_scroll_speed(new_speed: float):
	scroll_speed = new_speed
	
	# Update all star speeds proportionally
	for layer_index in range(stars.size()):
		var layer_stars = stars[layer_index]
		var layer_speed = scroll_speed * (layer_index + 1) * 0.3
		
		for star in layer_stars:
			star.speed = layer_speed
