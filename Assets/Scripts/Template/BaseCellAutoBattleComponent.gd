@abstract
extends Node
class_name BaseCellAutoBattleComponent

@export_group("Damage Parameters")
@export var cell_base_damage : int
@export var cell_current_damage : int

@export_group("Endurance Parameters")
@export var cell_base_endurance : int
@export var cell_current_endurance : int
@export var cell_max_endurance : int
@export var cell_gain_per_timer_endurance : int
@export var cell_endurance_timer : Timer


var is_attack_gain : bool = false
var target_cell : BaseCell


func _process(_delta: float) -> void:
	if is_attack_gain:
		try_hit_target()
		is_attack_gain = false


func try_hit_target():
	target_cell.cell_health_component.try_take_damage(cell_current_damage)
	

func restore_endurance():
	cell_current_endurance += cell_gain_per_timer_endurance
	
	if cell_current_endurance >= cell_max_endurance:
		cell_current_endurance = cell_max_endurance
		is_attack_gain = true

	
func set_target(target : BaseCell):
	target_cell = target
