@abstract
extends BaseCellMovementComponent
class_name WanderMovementComponent

## Wanders to a random nearby point, picking a new one on every timer tick.

const ARRIVAL_DISTANCE: float = 2.0
## Enemy sprites are drawn facing up, movement angles start from the right.
const SPRITE_ANGLE_OFFSET: float = PI / 2

@export_group("Random Movement Parameters")
@export var random_movement_timer_min_value: float = 1.3
@export var random_movement_timer_max_value: float = 2.4
@export var random_movement_timer: Timer
@export var random_movement_x_min_difference: int = -60
@export var random_movement_x_max_difference: int = 60
@export var random_movement_y_min_difference: int = -60
@export var random_movement_y_max_difference: int = 60

@export_group("Movement Feel")
@export var acceleration: float = 150.0
@export var friction: float = 200.0

var current_speed: float = 0.0


func _ready() -> void:
	super()
	_on_timer_timeout()


func move_cell(delta: float) -> void:
	var distance: float = body_to_move.global_position.distance_to(target_position)
	if distance < ARRIVAL_DISTANCE:
		current_speed = move_toward(current_speed, 0, friction * delta)
		body_to_move.velocity = Vector2.ZERO
		body_to_move.move_and_slide()
		return

	direction = body_to_move.global_position.direction_to(target_position)
	_steer(delta)


func random_timer() -> void:
	random_movement_timer.wait_time = randf_range(
		random_movement_timer_min_value,
		random_movement_timer_max_value
	)


## Connected in the movement component scenes to the wander Timer.timeout.
func _on_timer_timeout() -> void:
	var random_x: float = randf_range(
		random_movement_x_min_difference, random_movement_x_max_difference
	)
	var random_y: float = randf_range(
		random_movement_y_min_difference, random_movement_y_max_difference
	)
	target_position = body_to_move.global_position + Vector2(random_x, random_y)
	random_timer()


func _steer(delta: float) -> void:
	_turn_sprite(direction.angle() + SPRITE_ANGLE_OFFSET, delta)
	current_speed = move_toward(current_speed, cell_current_speed, acceleration * delta)
	body_to_move.velocity = direction * current_speed
	body_to_move.move_and_slide()
