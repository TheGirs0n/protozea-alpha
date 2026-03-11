extends BaseCellMovementComponent
class_name SimpleEnemyCellMovementComponent

@export_group("Random Movement Parameters")
@export var random_movement_timer_min_value : float = 2.5
@export var random_movement_timer_max_value : float = 5
@export var random_movement_timer : Timer
@export var random_movement_x_min_difference : int = -25
@export var random_movement_x_max_difference : int = 25
@export var random_movement_y_min_difference : int = -25
@export var random_movement_y_max_difference : int = 25

func _ready() -> void:
	cell_current_speed = cell_base_speed
	target_position = body_to_move.global_position
	
	random_timer()


func move_cell():
	var distance = body_to_move.global_position.distance_to(target_position)

	if distance < 2.0:
		body_to_move.velocity = Vector2.ZERO
		body_to_move.move_and_slide()
		return
	
	direction = body_to_move.global_position.direction_to(target_position)
	body_to_move.velocity = direction * cell_current_speed
	body_to_move.move_and_slide()
	
	
func _on_timer_timeout():
	var random_x = randf_range(random_movement_x_min_difference, random_movement_x_max_difference)
	var random_y = randf_range(random_movement_y_min_difference, random_movement_y_max_difference)
	target_position = body_to_move.global_position + Vector2(random_x, random_y)
	random_timer()
	
	
func random_timer():
	random_movement_timer.wait_time = randf_range(
		random_movement_timer_min_value,
		random_movement_timer_max_value
	)
