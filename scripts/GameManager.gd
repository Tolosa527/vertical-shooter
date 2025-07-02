extends Node
class_name GameManager

signal word_completed
signal game_over
signal score_updated(new_score: int)
signal level_changed(new_level: int)

@export var current_level: int = 1
@export var score: int = 0
@export var lives: int = 3

var word_data: Dictionary = {}
var current_word: String = ""
var collected_letters: Array[String] = []
var required_letters: Array[String] = []
var letters_in_order: bool = false
var next_letter_index: int = 0

var level_settings: Dictionary = {}
var translations: Dictionary = {}
var current_language: String = "en"

func _ready():
	load_word_data()
	setup_level(current_level)

func load_word_data():
	var file = FileAccess.open("res://data/word_banks.json", FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		
		if parse_result == OK:
			word_data = json.data
			translations = word_data.get("translations", {})
			current_language = word_data.get("game_settings", {}).get("default_language", "en")
		else:
			print("Error parsing word data: ", json.get_error_message())
	else:
		print("Could not open word data file")

func setup_level(level: int):
	current_level = level
	var levels = word_data.get("game_settings", {}).get("levels", [])
	
	if level <= levels.size():
		level_settings = levels[level - 1]
	else:
		# Use last level settings for higher levels
		level_settings = levels[-1].duplicate()
		level_settings["obstacle_speed"] += (level - levels.size()) * 25
		level_settings["obstacle_spawn_rate"] = max(0.5, level_settings["obstacle_spawn_rate"] - (level - levels.size()) * 0.1)
	
	letters_in_order = level_settings.get("letters_in_order", false)
	setup_new_word()
	level_changed.emit(current_level)

func setup_new_word():
	var word_bank_name = level_settings.get("word_bank", "basic")
	var word_banks = word_data.get("word_banks", {})
	var word_bank = word_banks.get(word_bank_name, {})
	var words = word_bank.get("words", ["CAT"])
	
	current_word = words[randi() % words.size()]
	collected_letters.clear()
	required_letters.clear()
	next_letter_index = 0
	
	# Create array of required letters
	for i in range(current_word.length()):
		required_letters.append(current_word[i])
	
	print("New word: ", current_word)
	print("Letters in order: ", letters_in_order)

func collect_letter(letter: String) -> bool:
	if letters_in_order:
		# Must collect letters in order
		if next_letter_index < required_letters.size() and letter == required_letters[next_letter_index]:
			collected_letters.append(letter)
			next_letter_index += 1
			add_score(10)
			
			if collected_letters.size() == required_letters.size():
				complete_word()
			return true
	else:
		# Can collect letters in any order
		if letter in required_letters and letter not in collected_letters:
			collected_letters.append(letter)
			add_score(10)
			
			if collected_letters.size() == required_letters.size():
				complete_word()
			return true
	
	return false

func complete_word():
	add_score(100)  # Bonus for completing word
	word_completed.emit()
	
	# Move to next level
	setup_level(current_level + 1)

func add_score(points: int):
	score += points
	score_updated.emit(score)

func lose_life():
	lives -= 1
	if lives <= 0:
		game_over.emit()

func get_word_display() -> String:
	var display = ""
	for i in range(current_word.length()):
		var letter = current_word[i]
		if letters_in_order:
			# Show letters up to the current position
			if i < next_letter_index:
				display += letter
			else:
				display += "_"
		else:
			# Show collected letters
			if letter in collected_letters:
				display += letter
			else:
				display += "_"
		
		if i < current_word.length() - 1:
			display += " "
	
	return display

func get_translation(key: String) -> String:
	var lang_translations = translations.get(current_language, {})
	return lang_translations.get(key, key)

func get_level_settings() -> Dictionary:
	return level_settings

func reset_game():
	score = 0
	lives = 3
	current_level = 1
	setup_level(1)
	score_updated.emit(score)
	level_changed.emit(current_level)
