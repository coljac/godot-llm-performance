shader_type canvas_item;

// Configurable parameters
uniform float wiggle_amount : hint_range(0.0, 20.0) = 5.0;
uniform float wiggle_speed : hint_range(0.0, 20.0) = 10.0;
uniform bool is_wiggling = false;

void vertex() {
    if (is_wiggling) {
        // Get time for animation
        float time = TIME * wiggle_speed;
        
        // Calculate wiggle offset using sine waves with some variation
        float offset_x = sin(time * 1.5 + VERTEX.y * 0.1) * wiggle_amount * 0.01;
        float offset_y = cos(time * 2.0 + VERTEX.x * 0.1) * wiggle_amount * 0.01;
        
        // Apply the wiggle offset to the vertex position
        VERTEX.x += offset_x;
        VERTEX.y += offset_y;
    }
}