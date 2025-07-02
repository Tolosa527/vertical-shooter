<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# Vertical Shooter Educational Game - Copilot Instructions

This is a Godot 4 educational vertical shooter game project with the following key characteristics:

## Project Overview
- **Engine**: Godot 4
- **Genre**: Educational vertical shooter with word collection mechanics
- **Art Style**: Pixel art, retro arcade theme
- **Target**: Educational game combining action with learning

## Core Gameplay Mechanics
- Player controls aircraft at bottom of screen
- Collect letters to complete words displayed at top
- Avoid/destroy environmental obstacles (asteroids, etc.)
- Simple controls: arrow keys for movement, spacebar for shooting
- Progressive difficulty with word complexity and obstacle behavior

## Technical Architecture
- Scene-based organization for easy level expansion
- Configuration files for word banks and translations
- Modular systems for obstacles, letters, and UI
- Pixel-perfect rendering with retro aesthetics

## Code Style Guidelines
- Use GDScript for all game logic
- Follow Godot naming conventions (snake_case for variables/functions)
- Organize scripts in logical folders (player/, enemies/, ui/, etc.)
- Comment complex game logic and configuration systems
- Use signals for loose coupling between systems

## File Organization
- Scenes organized by functionality (Player, UI, Levels, etc.)
- Scripts grouped by system type
- Assets organized by type (sprites/, sounds/, fonts/)
- Configuration files in data/ folder

When working on this project, prioritize:
1. Clean, readable GDScript code
2. Modular scene structure for easy expansion
3. Configurable systems for educational content
4. Smooth pixel art animations and effects
5. Responsive arcade-style gameplay
