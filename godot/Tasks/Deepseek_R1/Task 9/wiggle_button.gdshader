shader_type canvas_item;

uniform float intensity : hint_range(0, 2.0) = 0.5;
uniform bool active = false;

void vertex() {
    if (active) {
        VERTEX.x += sin(TIME * 30.0) * intensity * 2.0;
        VERTEX.y += cos(TIME * 25.0) * intensity * 1.5;
    }
}