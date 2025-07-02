# Vertical Shooter Educational Game

An educational vertical shooter game built with Godot 4, where players control an aircraft to collect letters and form words while avoiding obstacles. Perfect for combining arcade-style gameplay with language learning!

## Features

### Core Gameplay
- **Player Aircraft**: Control your ship with arrow keys at the bottom of the screen
- **Letter Collection**: Collect letters that fall from the sky to spell words
- **Word Formation**: Complete words displayed at the top of the screen
- **Obstacle Avoidance**: Dodge or destroy asteroids and other environmental hazards
- **Progressive Difficulty**: Levels get harder with faster obstacles and longer words

### Educational System
- **Configurable Word Banks**: Different categories (animals, colors, numbers, basic words)
- **Multiple Languages**: Support for translations and different languages
- **Order-Based Collection**: Higher levels require collecting letters in correct order
- **Adaptive Difficulty**: Speed and complexity increase with each level

### Technical Features
- **Pixel Art Style**: Retro arcade aesthetic with smooth animations
- **Scrolling Background**: Dynamic star field that moves with gameplay
- **Modular Design**: Easy to add new levels, words, and game mechanics
- **JSON Configuration**: External files for easy content management

## Installation

1. **Download Godot 4**: Get the latest version from [godotengine.org](https://godotengine.org/)

2. **Clone or Download**: Get this project to your local machine
   ```bash
   git clone [repository-url]
   cd vertical-shooter
   ```

3. **Open in Godot**: 
   - Launch Godot 4
   - Click "Import" 
   - Navigate to the project folder
   - Select `project.godot`
   - Click "Import & Edit"

4. **Run the Game**:
   - Press `F5` or click the play button
   - Select `Main.tscn` as the main scene when prompted

## Controls

- **Arrow Keys**: Move left and right
- **Spacebar**: Shoot bullets
- **R**: Restart game (when game over)

## Game Mechanics

### Level Progression
- **Level 1-2**: Collect letters in any order, basic words
- **Level 3+**: Must collect letters in correct sequence
- **Higher Levels**: Faster obstacles, longer words, more complex patterns

### Scoring System
- **Letter Collection**: 10 points per letter
- **Word Completion**: 100 bonus points
- **Obstacle Destruction**: 25 points per obstacle

### Obstacle Types
- **Static Asteroids**: Stationary obstacles (early levels)
- **Moving Asteroids**: Dynamic movement patterns (later levels)
- **Zigzag Pattern**: Unpredictable movement
- **Spiral Pattern**: Complex orbital movement

## Customization

### Adding New Words
Edit `data/word_banks.json` to add new word categories:

```json
{
  "word_banks": {
    "your_category": {
      "name": "Your Category Name",
      "description": "Description of your word bank",
      "words": ["WORD1", "WORD2", "WORD3"]
    }
  }
}
```

### Adding Translations
Add new languages in the translations section:

```json
{
  "translations": {
    "your_language": {
      "ui_score": "Your Score Text",
      "ui_word": "Your Word Text",
      "ui_level": "Your Level Text"
    }
  }
}
```

### Adjusting Difficulty
Modify level settings in `data/word_banks.json`:

```json
{
  "level": 1,
  "word_bank": "basic",
  "obstacle_speed": 50,
  "obstacle_spawn_rate": 2.0,
  "letters_in_order": false,
  "max_obstacles": 3
}
```

## Project Structure

```
vertical-shooter/
├── scenes/
│   ├── main/           # Main game scene
│   ├── player/         # Player character
│   ├── objects/        # Game objects (bullets, obstacles, letters)
│   └── ui/             # User interface
├── scripts/            # GDScript files
│   ├── GameManager.gd  # Core game logic
│   ├── Player.gd       # Player controller
│   ├── Spawner.gd      # Object spawning system
│   └── ...
├── assets/             # Art and audio assets
│   ├── sprites/        # Character and object sprites
│   └── icons/          # Game icons
├── data/               # Configuration files
│   └── word_banks.json # Word definitions and translations
└── project.godot       # Godot project file
```

## Development

### Adding New Features
1. Create new scripts in the `scripts/` folder
2. Add corresponding scenes in `scenes/`
3. Update `GameManager.gd` for core game logic
4. Test thoroughly with different difficulty levels

### Creating Custom Levels
1. Add level configuration to `word_banks.json`
2. Implement level-specific logic in `GameManager.gd`
3. Test progression and difficulty balance

### Asset Guidelines
- **Sprites**: Use pixel art style, 16x16 or 32x32 base sizes
- **Colors**: Bright, contrasting colors for visibility
- **Animations**: Smooth, arcade-style effects

## Educational Applications

This game can be used for:
- **Language Learning**: Vocabulary building and spelling practice
- **ESL Teaching**: English as Second Language instruction
- **Child Education**: Fun way to learn new words
- **Cognitive Training**: Hand-eye coordination with learning

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is open source. Feel free to use, modify, and distribute according to your needs.

## Credits

Created with Godot 4 game engine. Designed for educational use and retro gaming enthusiasts.

---

Have fun learning and playing! 🚀📚
