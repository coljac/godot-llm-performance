# Godot LLM performance benchmarks

These tests give an idea of how well current models perform on Godot tasks - writing GDScript, creating scenes and also making shaders.

As marked, some tests are naive or very self contained - "Give me the code snippet" - some are run with agentic capabilities, so the model can take advantage of the language parser and error messages from testing. 

**Please contribute.** If you have an idea for a test, please open an issue. If you have implemented an idea and have some results, feel free to open a pull request by adding the task to this file and the results to `results/`.

The godot project in this repository contains examples of the implmentations, working or not, for each task/model ran.

## Methodology

For 'complex' tasks with various moving pieces, the tasks are implemented in VSCode using [Roo Code](https://github.com/RooVetGit/Roo-Code) unless otherwise noted. Simple tasks are sent via a chat interface.

Prompt preamble:
```
You are an expert in version 4.4 of the Godot game engine. This is a task related to making scripts and scenes for a Godot project.

If you need to, you can consult the documentation at https://docs.godotengine.org/en/stable/.
```
The models may also be instructed where to put the files they create.

## The models

- OpenAI: ChatGPT 4.1 (gpt-4.1) O3 (o3...)
- Anthropic: Sonnet 3.7 (claude-3.7-sonnet-20250219, claude-3.7-sonnet-20250219:thinking)
- Gemini: Gemini Pro 2.5 (gemini-pro-exp-03-25)
- Deepseek: Deepseek R1 (deepseek-reasoner)

## Leaderboard (updated: 2025-04-16)

| Rank | Model      | 2D | 3D | Control | Shader | Total |
|------|------------|----|----|---------|--------|-------|
| 1 - | Sonnet 3.7 |  | 3.0 | 3.0 |  | 3.0 |
| 2 - | Gemini Pro 2.5 |  |  | 3.0 |  | 3.0 |
| 3 - | Deepseek R1 |  | 1.0 | 3.0 |  | 2.0 |
| 4 - | ChatGPT 4.1 |  | 1.0 | 2.0 |  | 1.5 |
| 5 - | o3-mini |  |  | 1.0 |  | 1.0 |




## Results

Achievement: ✅=works  ❌=broken  ❓=not applicable 😐=has issues
Score: 0=broken/useless 1=potentially useful/missed instructions 2=works 3=works perfectly

### GPT 4.1

| Task | Script | Scene | Shader | Score |  Notes |
|------|--------|-------|--------|-------|--------|
| 6 | ✅ | ❌ | - | 1 |  |
| 9 | ✅ | ❌ | - | 2 |  |




### o3-mini

| Task | Script | Scene | Shader | Score |  Notes |
|------|--------|-------|--------|-------|--------|
| 9 | ❌ | ❌ | ✅ | 1 | Only shader worked |




### Sonnet 3.7

| Task | Script | Scene | Shader | Score |  Notes |
|------|--------|-------|--------|-------|--------|
| 6 | ✅ | ✅ | - | 3 | Playable |
| 9 | ✅ | ✅ | ❌ | 3 | Over-engineered; shader faulty |




### Gemini Pro 2.5

| Task | Script | Scene | Shader | Score |  Notes |
|------|--------|-------|--------|-------|--------|
| 9 | ✅ | ✅ | - | 3 |  |




### Deepseek R1

| Task | Script | Scene | Shader | Score |  Notes |
|------|--------|-------|--------|-------|--------|
| 6 | ✅ | ❌ | - | 1 | invalid scene |
| 9 | ✅ | ✅ | ✅ | 3 |  |





## The tasks

| # | Task         | Type    | Complexity | Script | Scene | Shader | Notes |
|---|--------------|---------|------------|--------|-------|--------|-------|
| 9 | WiggleButton | Control | Low        | Y      | Y     | Y      | 1     |

Notes: <sup>1</sup> Roo Code

## Task details

Prompt preamble:
```

You are an expert in version 4.4 of the Godot game engine. This is a task related to making scripts and scenes for a Godot project.

If you need to, you can consult the documentation at https://docs.godotengine.org/en/stable/.

```

**Task 1: Plotting Component**

This is a Godot 4.4/GDScript task. Create a plotting component for the UI that:

- Provides a plotting area with defined x/y ranges (x_min, x_max, y_min, y_max).
- Has logic to translate between pixel and plot coordinate space.
- Draws axes with configurable tick spacing and colors.
- Has configurable background color.
- Accepts one or more series (of x/y points) to plot as points and/or lines with adjustable color and point size.
- Presents all the relevant options as export vars for use in the editor.

Make a demo scene to show the capabilities of the plotting component.

**Task 2: Flag Vertex Shader**

Develop a vertex shader in Godot 4.4 that simulates a flag waving the wind. The shader should:

- Animate a rectangular mesh to mimic flapping in the breeze.
- Use appropriate noise functions to vary vertex positions.
- Support adjustable parameters for wind strength and speed.

**Task 3: Flag scene**

We made a shader which is at res://Resources/flag.gdshader. Make a scene to use this flag waving shader. 

Create a 3D scene with:
- A WorldEnvironment
- A cylinder to be the flagpole
- A rectangular mesh to be the flag
- Shader material on the flag, to apply the flag vertext shader.

Apply the texture res://flag.png to the flag. Position a camera looking up at the flag from below.

**Task 4: Sprite2D Mouse Follower**

Write a script to attach to a Sprite2D node that follows the mouse pointer. The script should:

 - Update the sprite’s position to track the mouse.
 - Rotate the sprite at a speed proportional to the mouse movement speed.
 - Expose an export var for rotation speed.

**Task 5: 2D Time-of-Day Shader**

Create a 2D shader in Godot 4.4 that simulates time of day effects. Requirements include:

 - Adjusting color tones to create reddish/orange hues during dawn/dusk.
 - Gets brighter of the course of the day, very dim at night.
 - Allowing smooth transitions between different times of day.
 - Has a uniform for the time in the 24H cycle.

**Task 6: 3D Disappearing Cube**
Implement a 3D scene in Godot where a cube disappears if not in contact with the ground or another cube. The solution should:

 - Use collision detection to check contact with appropriate surfaces.
 - Start a timer when the cube is out of contact with the ground or another DisappearingCube. After the timer expires (the amount of time is a variable) it is freed.

Make a demo scene with a few disappearing cubes stacked together, and a way to push them around.

**Task 7: 3D Camera Orbit System**
Write a script for a Camera3D that orbits around a target object. The requirements are:

 - Use mouse input to control rotation and zoom.
 - Allow configurable orbit radius and speed of rotation.

**Task 8: Animated Gradient Progress Bar**

Implement a UI Control node in Godot for an animated progress bar that:

 - Displays progress with a gradient fill.
 - Animates transitions smoothly when progress changes.
 - Supports configurable gradient colors and animation speed.

**Task 9: WiggleButton**

Implement a UI Control node in Godot - a WiggleButton - a button that wiggles when moused over. The amount of wiggle should be configurable. The button should visibly shake and vibrate. This can be done with explicit draw instructions or with a shader.

Make a demo Control scene with a few WiggleButtons at different amounts of wiggle.
