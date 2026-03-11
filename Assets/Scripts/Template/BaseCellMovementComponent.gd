@abstract
extends Node
class_name BaseCellMovementComponent

@export_group("Base Speed Parameters")
@export var cell_base_speed : float
@export var cell_current_speed : float
@export var body_to_move : CharacterBody2D

var direction : Vector2
var target_position : Vector2


func _ready() -> void:
	cell_current_speed = cell_base_speed
	target_position = body_to_move.global_position


func _physics_process(_delta: float) -> void:
	move_cell()

func set_cell_move_speed(cell_swiftness : int):
	cell_current_speed = cell_swiftness * 100 - 50 * (cell_swiftness - 1)


func move_cell():
	pass
