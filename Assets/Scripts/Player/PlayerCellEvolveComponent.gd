extends Node
class_name PlayerEvolveComponent

@export var cell_evolve_array_cost : Array[int]

var cell_base_evolve_index : int = 0
var cell_current_evolve_index : int
var cell_max_evolve_index : int

var player_cell_max_damage : int = 6
var player_cell_max_defense : int = 6
var player_cell_max_speed : int = 6

var player_instance : PlayerCell

var can_player_evolve_in_total : bool = true

func _ready() -> void:
	cell_current_evolve_index = cell_base_evolve_index
	cell_max_evolve_index = cell_evolve_array_cost.size() - 1
	self.get_parent()


func player_evolve():
	if cell_current_evolve_index < cell_evolve_array_cost.size() - 1:
		cell_current_evolve_index += 1
	else:
		can_player_evolve_in_total = false
		
func can_player_evolve_current():
	if player_instance.player_economy_component.player_current_money >= cell_evolve_array_cost[cell_current_evolve_index]:
		pass
