@abstract
extends CharacterBody2D
class_name BaseCell

@export_group("Components")
@export var cell_health_component : BaseCellHealthComponent
@export var cell_movement_component : BaseCellMovementComponent
@export var cell_auto_battle_component : BaseCellAutoBattleComponent
@export var cell_animated_sprite_component : BaseCellAnimatedSprite

@export_group("Resource")
@export var cell_start_stats_resource : CellStartStatResource

var cell_strength_value : int = 0
var cell_immune_value : int = 0
var cell_swiftness_value : int = 0


func _enter_tree() -> void:
	set_base_stat()

func set_base_stat():
	if cell_health_component != null and cell_movement_component != null and cell_auto_battle_component != null:
		set_cell_strength(cell_start_stats_resource.cell_base_strength)
		set_cell_immune(cell_start_stats_resource.cell_base_immune)
		set_cell_swiftness(cell_start_stats_resource.cell_base_swiftness)
	

func set_cell_strength(new_value : int):
	cell_strength_value = new_value
	
	cell_auto_battle_component.cell_current_damage = 1 + (cell_strength_value - 1) * 0.5
	

func set_cell_immune(new_value : int):
	cell_immune_value = new_value
	
	cell_health_component.cell_current_defense = cell_immune_value * 5
	cell_health_component.cell_max_health = cell_immune_value + 2 * (cell_immune_value - 1)
	

func set_cell_swiftness(new_value : int):
	cell_swiftness_value = new_value
	
	cell_movement_component.cell_current_speed = cell_swiftness_value * 100 - 50 * (cell_swiftness_value - 1)
	cell_auto_battle_component.cell_max_endurance = 10 # Константа
	cell_auto_battle_component.cell_endurance_timer.wait_time = 0.5
	cell_auto_battle_component.cell_gain_per_timer_endurance = 3 - (0.3 - (cell_swiftness_value - 1))


func get_cell_strength() -> int:
	return cell_strength_value
	

func get_cell_immune() -> int:
	return cell_immune_value
	
	
func get_cell_swiftness() -> int:
	return cell_swiftness_value
