extends BaseCell
class_name EnemyCell


## Connected in EnemyCell.tscn to EnemyCellHealthComponent.cell_died.
func enemy_cell_die() -> void:
	var stat_summary: int = cell_strength_value + cell_immune_value + cell_swiftness_value
	var stat_random_bound: int = floori(stat_summary / 3.0)
	var money_to_player: int = randi_range(
		stat_summary - stat_random_bound,
		stat_summary + stat_random_bound
	)
	EventBus.money_earned.emit(money_to_player)
