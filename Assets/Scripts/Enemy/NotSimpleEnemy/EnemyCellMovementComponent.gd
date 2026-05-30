extends BaseCellMovementComponent
class_name EnemyCellMovementComponent

enum MOVEMENT_STATE { RANDOM, CHASE }

@export_group("Movement State")
@export var base_movement_state: MOVEMENT_STATE = MOVEMENT_STATE.RANDOM

@export_group("Move Patrol State Parameters")
@export var random_move_timer_min_value: float = 1.5
@export var random_move_timer_max_value: float = 3
@export var random_move_timer: Timer
@export var random_movement_x_min_difference: int = -75
@export var random_movement_x_max_difference: int = 75
@export var random_movement_y_min_difference: int = -75
@export var random_movement_y_max_difference: int = 75

@export_group("Move Chase State Parameters")
@export var move_speed_chase_modifier: float = 1.15
@export var chase_state_timer_value: float = 5
@export var chase_state_timer: Timer

@export_group("Movement Feel")
@export var acceleration: float = 200.0
@export var friction: float = 250.0

var current_movement_state: MOVEMENT_STATE
var chased_body: PlayerCell
var current_speed: float = 0.0


func _ready() -> void:
	cell_current_speed = cell_base_speed
	_sync_acceleration()
	target_position = body_to_move.global_position
	_on_timer_timeout()


func set_cell_move_speed(cell_swiftness: int) -> void:
	# FIX: переопределяем базовый метод, чтобы синхронизировать acceleration
	super.set_cell_move_speed(cell_swiftness)
	_sync_acceleration()


func _sync_acceleration() -> void:
	acceleration = cell_current_speed
	friction = cell_current_speed + 10


func move_cell() -> void:
	var delta := get_physics_process_delta_time()
	match current_movement_state:
		MOVEMENT_STATE.RANDOM:
			var distance := body_to_move.global_position.distance_to(target_position)
			if distance < 2.0:
				current_speed = move_toward(current_speed, 0, friction * delta)
				body_to_move.velocity = Vector2.ZERO
				body_to_move.move_and_slide()
				return

			direction = body_to_move.global_position.direction_to(target_position)
			var dir_angle := direction.angle() + PI / 2
			body_to_move.cell_animated_sprite_component.rotation = lerp_angle(
				body_to_move.cell_animated_sprite_component.rotation, dir_angle, 5.0 * delta
			)
			current_speed = move_toward(current_speed, cell_current_speed, acceleration * delta)
			body_to_move.velocity = direction * current_speed
			body_to_move.move_and_slide()

		MOVEMENT_STATE.CHASE:
			if chased_body == null:
				change_state(false)
				return

			direction = body_to_move.global_position.direction_to(chased_body.global_position)
			var dir_angle := direction.angle() + PI / 2
			body_to_move.cell_animated_sprite_component.rotation = lerp_angle(
				body_to_move.cell_animated_sprite_component.rotation, dir_angle, 5.0 * delta
			)
			current_speed = move_toward(current_speed, cell_current_speed, acceleration * delta)
			body_to_move.velocity = direction * current_speed
			body_to_move.move_and_slide()


func _on_chase_timer_timeout() -> void:
	change_state(false)


func _on_timer_timeout() -> void:
	var random_x := randf_range(random_movement_x_min_difference, random_movement_x_max_difference)
	var random_y := randf_range(random_movement_y_min_difference, random_movement_y_max_difference)
	target_position = body_to_move.global_position + Vector2(random_x, random_y)
	random_timer()


func random_timer() -> void:
	random_move_timer.wait_time = randf_range(
		random_move_timer_min_value, random_move_timer_max_value
	)


func change_state(is_chasing: bool) -> void:
	if is_chasing:
		current_movement_state = MOVEMENT_STATE.CHASE
		cell_current_speed = cell_base_speed * move_speed_chase_modifier
		_sync_acceleration()
		random_move_timer.stop()
		chase_state_timer.wait_time = chase_state_timer_value
		chase_state_timer.start()
	else:
		current_movement_state = MOVEMENT_STATE.RANDOM
		cell_current_speed = cell_base_speed
		_sync_acceleration()
		chased_body = null
		chase_state_timer.stop()
		_on_timer_timeout()
		random_move_timer.start()


func player_enter_area(body: Node2D) -> void:
	if body is PlayerCell:
		change_state(true)
		chased_body = body
