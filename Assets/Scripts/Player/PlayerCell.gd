extends BaseCell
class_name PlayerCell

@export var player_economy_component : PlayerEconomyComponent
@export var player_evolve_component : PlayerEvolveComponent

func _enter_tree() -> void:
	GlobalContext.player_instance = self
	
	
func player_cell_add_one_strength():
	set_cell_strength(cell_strength_value + 1)
	set_cell_size_scale()
	

func player_cell_add_one_immune():
	set_cell_immune(cell_immune_value + 1)
	set_cell_size_scale()
	

func player_cell_add_one_swiftness():
	set_cell_swiftness(cell_swiftness_value + 1)
	set_cell_size_scale()
	

func ping_ui_update_stats():
	GlobalContext.main_ui_instance.update_player_stats(cell_strength_value, cell_immune_value, cell_swiftness_value)

	
func _exit_tree() -> void:
	GlobalContext.player_instance = null
