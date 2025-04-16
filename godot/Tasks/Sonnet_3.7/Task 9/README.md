# WiggleButton for Godot 4.4

A custom UI Control node for Godot 4.4 that wiggles when moused over, with configurable wiggle amount and speed.

## Features

- Two different implementations:
  - Position-based wiggle (manipulates the button's position)
  - Shader-based wiggle (uses a vertex shader for the effect)
- Configurable wiggle amount and speed
- Simple to use in any Godot project

## Usage

### Adding a WiggleButton to your scene

1. Add a regular Button node to your scene
2. Attach either `wiggle_button.gd` or `shader_wiggle_button.gd` script to the button
3. Configure the wiggle amount and speed in the Inspector

### Properties

Both implementations share the same configurable properties:

- **Wiggle Amount**: Controls how far the button wiggles (default: 5.0)
- **Wiggle Speed**: Controls how fast the button wiggles (default: 10.0)

### Methods

Both implementations provide the following methods:

- **trigger_wiggle(duration: float = 1.0)**: Manually triggers the wiggle effect for the specified duration in seconds

### Example

```gdscript
# Creating a WiggleButton in code
var wiggle_button = Button.new()
wiggle_button.text = "Wiggle Me!"
wiggle_button.set_script(load("res://wiggle_button.gd"))
wiggle_button.wiggle_amount = 8.0
wiggle_button.wiggle_speed = 12.0
add_child(wiggle_button)

# Manually triggering the wiggle effect
wiggle_button.trigger_wiggle(2.0)  # Wiggle for 2 seconds
```

## Implementation Details

### Position-based WiggleButton (`wiggle_button.gd`)

This implementation manipulates the button's position using sine waves with some randomness to create a natural wiggle effect. It's simple to understand and modify.

### Shader-based WiggleButton (`shader_wiggle_button.gd` and `wiggle_shader.gdshader`)

This implementation uses a vertex shader to manipulate the vertices of the button, creating a more efficient wiggle effect that can be more visually interesting for complex shapes.

## Demo

The project includes four demo scenes:

1. `wiggle_button_demo.tscn` - Demonstrates the position-based WiggleButton
2. `shader_wiggle_button_demo.tscn` - Demonstrates the shader-based WiggleButton
3. `programmatic_wiggle_button_demo.tscn` - Shows how to create WiggleButtons programmatically
4. `wiggle_button_main_demo.tscn` - Main demo that allows switching between all implementations

## License

This code is provided under the MIT License.