shader_type canvas_item;

uniform float amplitude = 2.0; 
uniform float speed = 1.5;

void vertex() {
    float t = TIME * speed;
    
    float offset_x = sin(t + VERTEX.y * 0.01) * amplitude;
    float offset_y = cos(t * 1.3 + VERTEX.x * 0.01) * amplitude * 0.8;
    
    VERTEX.x += offset_x;
    VERTEX.y += offset_y;
}