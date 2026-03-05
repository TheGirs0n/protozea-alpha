@abstract
extends Sprite2D
class_name BaseCellAnimatedSprite

@export_group("Timers")
@export var min_timer_value : float = 2.5
@export var max_timer_value : float = 5
@export var rotate_tween_timer : Timer
@export var scale_tween_timer : Timer

@export_group("Scale Parameters")
@export var min_sprite_scale = 0.95
@export var max_sprite_scale = 1.05

@export_group("Rotate Parameters")
@export var min_sprite_rotate = 0
@export var max_sprite_rotate = 360

var rotate_tween : Tween
var scale_tween : Tween
var scale_vector : Vector2

func _ready() -> void:
	rotate_tween_timer.wait_time = randf_range(min_timer_value, max_timer_value)
	scale_tween_timer.wait_time = randf_range(min_timer_value, max_timer_value)
	
	rotate_tween_timer.start()
	scale_tween_timer.start()

func change_rotate_parameters():
	var new_rotate_value = randf_range(min_sprite_rotate, max_sprite_rotate)
	
	if rotate_tween:
		rotate_tween.kill()
		
	rotate_tween = create_tween()
	rotate_tween.set_trans(Tween.TRANS_QUAD)
	rotate_tween.set_ease(Tween.EASE_IN_OUT)
	rotate_tween.tween_property(self, "rotation_degrees", new_rotate_value, rotate_tween_timer.wait_time)
	
	rotate_tween_timer.wait_time = randf_range(min_timer_value, max_timer_value)
	rotate_tween_timer.start()
	
func change_scale_parameters():
	var new_scale_value_x = randf_range(min_sprite_scale, max_sprite_scale)
	var new_scale_value_y = randf_range(min_sprite_scale, max_sprite_scale)
	scale_vector = Vector2(new_scale_value_x, new_scale_value_y)
	
	if scale_tween:
		rotate_tween.kill()
		
	scale_tween = create_tween()
	scale_tween.set_trans(Tween.TRANS_QUAD)
	scale_tween.set_ease(Tween.EASE_IN_OUT)
	scale_tween.tween_property(self, "scale", scale_vector, scale_tween_timer.wait_time)
	
	scale_tween_timer.wait_time = randf_range(min_timer_value, max_timer_value)
	scale_tween_timer.start()
