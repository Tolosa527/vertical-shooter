extends EditorScript

# This script generates placeholder textures for the game objects
# Run this script in Godot's editor to create basic colored rectangles for sprites

func _run():
	print("Generating placeholder textures...")
	
	# Create assets/sprites directory if it doesn't exist
	var dir = DirAccess.open("res://")
	if not dir.dir_exists("assets/sprites"):
		dir.make_dir_recursive("assets/sprites")
	
	# Generate player sprite (cyan triangle)
	create_player_sprite()
	
	# Generate bullet sprite (green rectangle)
	create_bullet_sprite()
	
	# Generate obstacle sprite (red/orange irregular shape)
	create_obstacle_sprite()
	
	# Generate letter background sprite (yellow circle)
	create_letter_sprite()
	
	print("Placeholder textures generated successfully!")

func create_player_sprite():
	var image = Image.create(24, 32, false, Image.FORMAT_RGBA8)
	
	# Fill with transparent
	image.fill(Color(0, 0, 0, 0))
	
	# Draw cyan triangle (player ship)
	for y in range(32):
		for x in range(24):
			var center_x = 12
			var triangle_width = int((32 - y) * 0.75)
			
			if abs(x - center_x) <= triangle_width / 2:
				image.set_pixel(x, y, Color.CYAN)
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	ResourceSaver.save(texture, "res://assets/sprites/player.tres")

func create_bullet_sprite():
	var image = Image.create(4, 8, false, Image.FORMAT_RGBA8)
	image.fill(Color.LIME)  # Bright green
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	ResourceSaver.save(texture, "res://assets/sprites/bullet.tres")

func create_obstacle_sprite():
	var image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	
	# Fill with transparent
	image.fill(Color(0, 0, 0, 0))
	
	# Draw irregular asteroid shape
	var center = Vector2(16, 16)
	var base_radius = 14
	
	for y in range(32):
		for x in range(32):
			var pos = Vector2(x, y)
			var distance = pos.distance_to(center)
			
			# Add some noise for irregular shape
			var noise = sin(x * 0.5) * cos(y * 0.3) * 3
			var effective_radius = base_radius + noise
			
			if distance <= effective_radius:
				# Gradient from orange to red
				var intensity = 1.0 - (distance / effective_radius) * 0.3
				image.set_pixel(x, y, Color(1.0, 0.4 * intensity, 0.2 * intensity, 1.0))
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	ResourceSaver.save(texture, "res://assets/sprites/obstacle.tres")

func create_letter_sprite():
	var image = Image.create(24, 24, false, Image.FORMAT_RGBA8)
	
	# Fill with transparent
	image.fill(Color(0, 0, 0, 0))
	
	# Draw yellow circle
	var center = Vector2(12, 12)
	var radius = 10
	
	for y in range(24):
		for x in range(24):
			var pos = Vector2(x, y)
			var distance = pos.distance_to(center)
			
			if distance <= radius:
				# Gradient yellow circle
				var intensity = 1.0 - (distance / radius) * 0.3
				image.set_pixel(x, y, Color(1.0, 1.0 * intensity, 0.2, 0.8))
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	ResourceSaver.save(texture, "res://assets/sprites/letter.tres")
