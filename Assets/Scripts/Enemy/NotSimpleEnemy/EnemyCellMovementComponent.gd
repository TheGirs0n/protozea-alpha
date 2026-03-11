extends BaseCellMovementComponent
class_name EnemyCellMovementComponent

enum MOVEMENT_STATE{
	RANDOM,
	CHASE
}

@export_group("Movement State")
@export var base_movement_state : MOVEMENT_STATE = MOVEMENT_STATE.RANDOM

@export_group("Move Patrol State Parameters")
@export var random_move_timer_min_value : float = 1.5
@export var random_move_timer_max_value : float = 3
@export var random_move_timer : Timer
@export var random_movement_x_min_difference : int = -75
@export var random_movement_x_max_difference : int = 75
@export var random_movement_y_min_difference : int = -75
@export var random_movement_y_max_difference : int = 75

@export_group("Move Chase State Parameters")
@export var move_speed_chase_modifier : float = 1.15
@export var chase_state_timer_value : float = 5
@export var chase_state_timer : Timer

var current_movement_state : MOVEMENT_STATE
var chased_body : PlayerCell

func _ready() -> void:
	cell_current_speed = cell_base_speed
	target_position = body_to_move.global_position
	
	random_timer()


func move_cell():
	match current_movement_state:
		MOVEMENT_STATE.RANDOM:
			var distance = body_to_move.global_position.distance_to(target_position)
			
			if distance < 2.0:
				body_to_move.velocity = Vector2.ZERO
				body_to_move.move_and_slide()
				return
			
			direction = body_to_move.global_position.direction_to(target_position)
			body_to_move.velocity = direction * cell_current_speed
			body_to_move.move_and_slide()
		MOVEMENT_STATE.CHASE:
			if chased_body == null:
				change_state(false)
				return
			direction = body_to_move.global_position.direction_to(chased_body.global_position)
			body_to_move.velocity = direction * cell_current_speed
			body_to_move.move_and_slide()
			
			
func _on_chase_timer_timeout():
	change_state(false)


func _on_timer_timeout():
	var random_x = randf_range(random_movement_x_min_difference, random_movement_x_max_difference)
	var random_y = randf_range(random_movement_y_min_difference, random_movement_y_max_difference)
	target_position = body_to_move.global_position + Vector2(random_x, random_y)
	random_timer()
	
	
func random_timer():
	random_move_timer.wait_time = randf_range(
		random_move_timer_min_value,
		random_move_timer_max_value
	)

func change_state(is_chasing: bool):
	if is_chasing:
		current_movement_state = MOVEMENT_STATE.CHASE
		cell_current_speed = cell_base_speed * move_speed_chase_modifier  
		random_move_timer.stop()
		chase_state_timer.wait_time = chase_state_timer_value
		chase_state_timer.start()
	else:
		current_movement_state = MOVEMENT_STATE.RANDOM
		cell_current_speed = cell_base_speed  
		chased_body = null
		chase_state_timer.stop()
		_on_timer_timeout()
		random_move_timer.start()


func player_enter_area(body: Node2D) -> void:
	if body is PlayerCell:
		change_state(true)
		chased_body = body
