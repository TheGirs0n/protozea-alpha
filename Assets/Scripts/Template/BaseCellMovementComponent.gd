@abstract
extends Node
class_name BaseCellMovementComponent

@export_group("Base Speed Parameters")
@export var cell_base_speed: float
@export var cell_current_speed: float
@export var body_to_move: BaseCell

var direction: Vector2
var target_position: Vector2


func _ready() -> void:
	cell_current_speed = cell_base_speed
	target_position = body_to_move.global_position


func _physics_process(delta: float) -> void:
	move_cell(delta)


func set_cell_move_speed(cell_swiftness: int) -> void:
	# Base speed comes from the stat; states like chase scale it and return to it
	cell_base_speed = cell_swiftness * 60 - 50 * (cell_swiftness - 1)
	cell_current_speed = cell_base_speed


func disable_component() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func enable_component() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT


@abstract func move_cell(delta: float) -> void
