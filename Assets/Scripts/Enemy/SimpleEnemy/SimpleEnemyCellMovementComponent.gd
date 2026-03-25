extends BaseCellMovementComponent
class_name SimpleEnemyCellMovementComponent

@export_group("Random Movement Parameters")
@export var random_movement_timer_min_value : float = 1.3 # было 2.5
@export var random_movement_timer_max_value : float = 2.4  # было 5
@export var random_movement_timer : Timer
@export var random_movement_x_min_difference : int = -60   # было -25
@export var random_movement_x_max_difference : int = 60    # было 25
@export var random_movement_y_min_difference : int = -60   # было -25
@export var random_movement_y_max_difference : int = 60    # было 25int = 25
@export_group("Movement Feel")
@export var acceleration : float = 150.0
@export var friction : float = 200.0

var current_speed : float = 0.0

func _ready() -> void:
	cell_current_speed = cell_base_speed
	target_position = body_to_move.global_position
	
	_on_timer_timeout()


func move_cell():
	var distance = body_to_move.global_position.distance_to(target_position)
	if distance < 2.0:
		current_speed = move_toward(current_speed, 0, friction * get_physics_process_delta_time())
		body_to_move.velocity = Vector2.ZERO
		body_to_move.move_and_slide()
		#_on_timer_timeout()
		return
	
	direction = body_to_move.global_position.direction_to(target_position)
	current_speed = move_toward(current_speed, cell_current_speed, acceleration * get_physics_process_delta_time())
	body_to_move.velocity = direction * current_speed
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
