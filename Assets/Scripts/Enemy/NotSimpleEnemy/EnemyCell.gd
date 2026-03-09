extends BaseCell
class_name EnemyCell


func enemy_cell_die() -> void:
	var stat_summary : int = cell_strength_value + cell_immune_value + cell_swiftness_value
	var stat_random_bound : int = stat_summary / 3
	var money_to_player : int = randi_range(stat_summary - stat_random_bound, stat_summary + stat_random_bound)
	
	GlobalContext.player_instance.player_economy_component.add_money(money_to_player)
