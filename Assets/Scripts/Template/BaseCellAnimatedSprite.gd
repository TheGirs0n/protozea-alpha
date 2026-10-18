@abstract
extends Sprite2D
class_name BaseCellAnimatedSprite

@export_group("Timers")
@export var min_timer_value: float = 2.5
@export var max_timer_value: float = 5
@export var scale_tween_timer: Timer

@export_group("Scale Parameters")
@export var min_sprite_scale: float = 0.95
@export var max_sprite_scale: float = 1.05

var scale_tween: Tween
var scale_vector: Vector2

# Scale from the scene; breathing oscillates around it instead of compounding
var _base_scale: Vector2


func _ready() -> void:
	_base_scale = scale
	scale_tween_timer.wait_time = randf_range(min_timer_value, max_timer_value)
	scale_tween_timer.start()


## Connected in the sprite component scenes to ScaleTimer.timeout.
func change_scale_parameters() -> void:
	scale_vector = randf_range(min_sprite_scale, max_sprite_scale) * _base_scale

	if scale_tween:
		scale_tween.kill()

	scale_tween = create_tween()
	scale_tween.set_trans(Tween.TRANS_QUAD)
	scale_tween.set_ease(Tween.EASE_IN_OUT)
	scale_tween.tween_property(self, "scale", scale_vector, scale_tween_timer.wait_time)

	scale_tween_timer.wait_time = randf_range(min_timer_value, max_timer_value)
	scale_tween_timer.start()
