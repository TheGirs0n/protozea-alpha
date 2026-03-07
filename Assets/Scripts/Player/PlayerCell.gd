extends BaseCell
class_name PlayerCell

@export var player_economy_component : PlayerEconomyComponent
@export var player_evolve_component : PlayerEvolveComponent


func player_cell_add_one_strength():
	set_cell_strength(++cell_strength_value)
	GlobalContext.main_ui_instance.update_player_stats(cell_strength_value, cell_immune_value, cell_swiftness_value)


func player_cell_add_one_immune():
	set_cell_immune(++cell_immune_value)
	GlobalContext.main_ui_instance.update_player_stats(cell_strength_value, cell_immune_value, cell_swiftness_value)


func player_cell_add_one_swiftness():
	set_cell_swiftness(++cell_swiftness_value)
	GlobalContext.main_ui_instance.update_player_stats(cell_strength_value, cell_immune_value, cell_swiftness_value)


func _ready() -> void:
	GlobalContext.player_instance = self
	if GlobalContext.main_ui_instance != null:
		GlobalContext.main_ui_instance.update_player_stats(cell_strength_value, cell_immune_value, cell_swiftness_value)
	
	
func _exit_tree() -> void:
	GlobalContext.player_instance = null
