extends BaseCell
class_name EnemyCell

@export_group("Reward")
## Reward is the stat sum plus or minus (stat sum / reward_spread_divisor).
@export var reward_spread_divisor: int = 3


## Connected in EnemyCell.tscn to EnemyCellHealthComponent.cell_died.
func enemy_cell_die() -> void:
	var stat_summary: int = cell_strength_value + cell_immune_value + cell_swiftness_value
	var stat_random_bound: int = floori(float(stat_summary) / reward_spread_divisor)
	var money_to_player: int = randi_range(
		stat_summary - stat_random_bound,
		stat_summary + stat_random_bound
	)
	EventBus.money_earned.emit(money_to_player)
