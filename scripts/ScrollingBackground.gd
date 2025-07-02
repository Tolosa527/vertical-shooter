extends Node2D
class_name ScrollingBackground

@export var scroll_speed: float = 50.0
@export var star_count: int = 100
@export var star_layers: int = 3
@export var background_color: Color = Color(0.05, 0.05, 0.1, 1.0)  # Very dark blue-black
@export var show_nebula: bool = true  # Add subtle nebula effects

var screen_size: Vector2
var stars: Array[Array] = []
var nebula_particles: Array = []

func _ready():
	screen_size = get_viewport_rect().size
	generate_stars()
	if show_nebula:
		generate_nebula_particles()

func generate_nebula_particles():
	# Create very subtle, slow-moving nebula particles
	for i in range(15):
		var particle = {
			"position": Vector2(
				randf() * screen_size.x,
				randf() * screen_size.y
			),
			"speed": randf_range(5.0, 15.0),
			"size": randf_range(20.0, 60.0),
			"color": Color(
				randf_range(0.1, 0.2),  # Very dark red
				randf_range(0.05, 0.15), # Very dark green
				randf_range(0.15, 0.25), # Slightly more blue
				randf_range(0.05, 0.15)  # Very transparent
			)
		}
		nebula_particles.append(particle)

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
				"brightness": 0.15 + layer * 0.15  # Much dimmer stars
			}
			layer_stars.append(star)
		
		stars.append(layer_stars)

func _draw():
	# Draw dark background first
	draw_rect(Rect2(Vector2.ZERO, screen_size), background_color)
	
	# Draw nebula particles (very subtle)
	if show_nebula:
		for particle in nebula_particles:
			draw_circle(particle.position, particle.size, particle.color)
	
	# Draw all star layers
	for layer_index in range(stars.size()):
		var layer_stars = stars[layer_index]
		var brightness = 0.15 + layer_index * 0.15  # Much dimmer stars
		
		# Create subtle color variations for stars
		var star_color: Color
		match layer_index:
			0:  # Distant stars - very dim blue-white
				star_color = Color(0.4, 0.4, 0.6, brightness)
			1:  # Medium stars - dim white
				star_color = Color(0.5, 0.5, 0.5, brightness)
			2:  # Close stars - slightly brighter white
				star_color = Color(0.6, 0.6, 0.7, brightness)
			_:
				star_color = Color(brightness, brightness, brightness, 1.0)
		
		for star in layer_stars:
			var size = star.size
			draw_circle(star.position, size, star_color)

func _process(delta):
	# Move stars down
	for layer_stars in stars:
		for star in layer_stars:
			star.position.y += star.speed * delta
			
			# Wrap around when star goes off screen
			if star.position.y > screen_size.y + 10:
				star.position.y = -10
				star.position.x = randf() * screen_size.x
	
	# Move nebula particles (very slowly)
	if show_nebula:
		for particle in nebula_particles:
			particle.position.y += particle.speed * delta
			
			# Wrap around when particle goes off screen
			if particle.position.y > screen_size.y + particle.size:
				particle.position.y = -particle.size
				particle.position.x = randf() * screen_size.x
	
	# Redraw everything
	queue_redraw()

func set_scroll_speed(new_speed: float):
	scroll_speed = new_speed
	
	# Update all star speeds proportionally
	for layer_index in range(stars.size()):
		var layer_stars = stars[layer_index]
		var layer_speed = scroll_speed * (layer_index + 1) * 0.3
		
		for star in layer_stars:
			star.speed = layer_speed
