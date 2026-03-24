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

var cell_base_scale : Vector2 = Vector2(0.5, 0.5)
var cell_base_increase_per_level_scale : Vector2 = Vector2(0.05, 0.05)

var size_tween : Tween

signal cell_stats_changed


func _ready() -> void:
	set_base_stat()


func set_base_stat():
	if cell_health_component != null and cell_movement_component != null and cell_auto_battle_component != null:
		set_cell_strength(cell_start_stats_resource.cell_base_strength)
		set_cell_immune(cell_start_stats_resource.cell_base_immune)
		set_cell_swiftness(cell_start_stats_resource.cell_base_swiftness)
		set_cell_size_scale()


func set_cell_strength(new_value : int):
	cell_strength_value = new_value
	
	cell_auto_battle_component.set_cell_strength_parameters(cell_strength_value)
	cell_stats_changed.emit()
	

func set_cell_immune(new_value : int):
	cell_immune_value = new_value
	
	cell_health_component.set_cell_health_parameters(cell_immune_value)
	cell_stats_changed.emit()
	

func set_cell_swiftness(new_value : int):
	cell_swiftness_value = new_value
	
	cell_movement_component.set_cell_move_speed(cell_swiftness_value)
	cell_auto_battle_component.set_cell_swiftness_parameters(cell_swiftness_value)
	cell_stats_changed.emit()


func set_cell_size_scale():
	var new_size_modifier = cell_strength_value - 1 + cell_immune_value - 1 + cell_swiftness_value - 1
	var new_size_out_base = cell_base_scale + cell_base_increase_per_level_scale * new_size_modifier
	#self.scale = new_size_out_base
	if size_tween:
		size_tween.kill()
	
	size_tween = create_tween()
	size_tween.set_ease(Tween.EASE_OUT)
	size_tween.set_trans(Tween.TRANS_QUAD)
	size_tween.tween_property(self, "scale", new_size_out_base, 0.25)
