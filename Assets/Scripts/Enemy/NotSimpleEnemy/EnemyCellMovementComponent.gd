extends BaseCellMovementComponent
class_name EnemyCellMovementComponent

@export_group("Move Patrol State Parameters")
@export var move_timer_min_value : float = 1.5
@export var move_timer_max_value : float = 3
@export var move_timer : Timer

@export_group("Move Chase State Parameters")
@export var move_speed_chase_modifier : float = 1.15
@export var chase_state_timer_value : float
@export var chase_state_timer : Timer
