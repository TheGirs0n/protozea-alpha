extends WanderMovementComponent
class_name EnemyCellMovementComponent

## Wanders like plankton and chases the player for a while after noticing it.

enum MovementState { NONE, RANDOM, CHASE }

@export_group("Move Chase State Parameters")
@export var move_speed_chase_modifier: float = 1.15
@export var chase_state_timer_value: float = 5
@export var chase_state_timer: Timer

var current_movement_state: MovementState = MovementState.NONE
var chased_body: PlayerCell


func _ready() -> void:
	super()
	current_movement_state = MovementState.RANDOM
	_sync_acceleration()


func set_cell_move_speed(cell_swiftness: int, balance: CellBalanceConfig) -> void:
	# Keep acceleration in sync with the stat speed
	super.set_cell_move_speed(cell_swiftness, balance)
	_sync_acceleration()


func move_cell(delta: float) -> void:
	match current_movement_state:
		MovementState.RANDOM:
			super.move_cell(delta)

		MovementState.CHASE:
			if not is_instance_valid(chased_body):
				change_state(false)
				return

			direction = body_to_move.global_position.direction_to(chased_body.global_position)
			_steer(delta)


func change_state(is_chasing: bool) -> void:
	if is_chasing:
		current_movement_state = MovementState.CHASE
		cell_current_speed = cell_base_speed * move_speed_chase_modifier
		_sync_acceleration()
		random_movement_timer.stop()
		chase_state_timer.wait_time = chase_state_timer_value
		chase_state_timer.start()
	else:
		current_movement_state = MovementState.RANDOM
		cell_current_speed = cell_base_speed
		_sync_acceleration()
		chased_body = null
		chase_state_timer.stop()
		_on_timer_timeout()
		random_movement_timer.start()


## Connected in EnemyCell.tscn to PlayerAreaContact.body_entered.
func player_enter_area(body: Node2D) -> void:
	var player: PlayerCell = body as PlayerCell
	if player == null:
		return

	change_state(true)
	chased_body = player


## Connected in EnemyCellMovementComponent.tscn to ChaseTimer.timeout.
func _on_chase_timer_timeout() -> void:
	change_state(false)


## Acceleration and friction follow the current speed instead of the exported values.
func _sync_acceleration() -> void:
	acceleration = cell_current_speed
	friction = cell_current_speed + 10
