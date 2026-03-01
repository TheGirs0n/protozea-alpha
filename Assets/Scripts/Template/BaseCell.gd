@abstract
extends CharacterBody2D
class_name BaseCell

@export_group("Components")
@export var cell_health_component : BaseCellHealthComponent
@export var cell_movement_component : BaseCellMovementComponent
@export var cell_auto_battle_component : BaseCellAutoBattleComponent

@export_group("Resource")
@export var cell_start_stats_resource : CellStartStatResource


func _enter_tree() -> void:
	if cell_health_component != null:
		cell_health_component.cell_max_health = cell_start_stats_resource.cell_base_health
		cell_health_component.cell_base_defense = cell_start_stats_resource.cell_base_defense
	
	if cell_movement_component != null:
		cell_movement_component.cell_base_speed = cell_start_stats_resource.cell_base_speed
	
	if cell_auto_battle_component != null:
		cell_auto_battle_component.cell_base_damage = cell_start_stats_resource.cell_base_damage
		cell_auto_battle_component.cell_base_endurance = cell_start_stats_resource.cell_base_endurance
