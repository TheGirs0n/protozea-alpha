extends Node
class_name PlayerEvolveComponent

@export var cell_evolve_array_cost : Array[int]

var cell_base_evolve_index : int = 0
var cell_current_evolve_index : int
var cell_max_evolve_index : int

var player_cell_max_damage : int = 6
var player_cell_max_defense : int = 6
var player_cell_max_speed : int = 6

func _ready() -> void:
	cell_current_evolve_index = cell_base_evolve_index
	cell_max_evolve_index = cell_evolve_array_cost.size() - 1

func player_evolve():
	pass
