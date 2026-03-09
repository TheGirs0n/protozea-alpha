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

var can_player_evolve_in_current : bool = false
var can_player_evolve_in_total : bool = true

signal player_click_evolve(player_strenght : int, player_immune : int, player_swiftness : int)

func _ready() -> void:
	cell_current_evolve_index = cell_base_evolve_index
	cell_max_evolve_index = cell_evolve_array_cost.size() - 1
	self.get_parent()


func _input(event: InputEvent) -> void:
	if can_player_evolve_in_current == false:
		return
		
	if event.is_action_pressed("try_evolve"):
		player_click_evolve.emit(player_instance.cell_strength_value, 
		player_instance.cell_immune_value,
		player_instance.cell_swiftness_value)


func player_evolve():
	if cell_current_evolve_index < cell_evolve_array_cost.size() - 1:
		cell_current_evolve_index += 1
	else:
		can_player_evolve_in_total = false
		
	
func can_player_evolve_current():
	if player_instance.player_economy_component.player_current_money >= cell_evolve_array_cost[cell_current_evolve_index]:
		can_player_evolve_in_current = true
