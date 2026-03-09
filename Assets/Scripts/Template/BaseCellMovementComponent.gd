@abstract
extends Node
class_name BaseCellMovementComponent

@export_group("Base Speed Parameters")
@export var cell_base_speed : float
@export var cell_current_speed : float

var direction : Vector2
var body_to_move : CharacterBody2D


func _ready() -> void:
	body_to_move = get_parent()
	cell_current_speed = cell_base_speed


func _physics_process(_delta: float) -> void:
	move_cell()


func move_cell():
	pass
