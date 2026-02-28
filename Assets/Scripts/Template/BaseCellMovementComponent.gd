@abstract
extends Node
class_name BaseCellMovementComponent

@export var cell_base_speed : float
@export var cell_current_speed : float

var direction : Vector2
var body_to_move : BaseCell


func _ready() -> void:
	body_to_move = get_parent()
	cell_current_speed = cell_base_speed

func move_cell():
	pass
