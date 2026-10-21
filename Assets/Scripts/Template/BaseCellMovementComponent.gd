@abstract
extends Node
class_name BaseCellMovementComponent

@export_group("Base Speed Parameters")
## Starting speed; cells with stats replace it with the speed from swiftness.
@export var cell_base_speed: float
@export var body_to_move: CellBody
## How fast the sprite turns towards the movement direction.
@export var turn_speed: float = 5.0

var cell_current_speed: float
var direction: Vector2
var target_position: Vector2


func _ready() -> void:
	cell_current_speed = cell_base_speed
	target_position = body_to_move.global_position


func _physics_process(delta: float) -> void:
	move_cell(delta)


func set_cell_move_speed(cell_swiftness: int, balance: CellBalanceConfig) -> void:
	# Base speed comes from the stat; states like chase scale it and return to it
	cell_base_speed = balance.speed(cell_swiftness)
	cell_current_speed = cell_base_speed


func disable_component() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func enable_component() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT


@abstract func move_cell(delta: float) -> void


func _turn_sprite(angle: float, delta: float) -> void:
	var sprite: Node2D = body_to_move.cell_animated_sprite_component
	sprite.rotation = lerp_angle(sprite.rotation, angle, turn_speed * delta)
