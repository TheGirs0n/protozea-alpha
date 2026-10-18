extends Resource
class_name CellBalanceConfig

## How cell stats turn into battle, movement and size numbers.
## Every value grows linearly with the stat: at_level_one + per_level * (stat - 1).

@export_group("Stat Range")
## Range for random stats and the cap regular evolve cards raise a stat to.
@export var min_stat: int = 1
@export var max_stat: int = 5

@export_group("Strength")
@export var damage_at_level_one: float = 1.0
@export var damage_per_level: float = 0.5

@export_group("Immune")
@export var health_at_level_one: float = 5.0
@export var health_per_level: float = 2.0
## Chance in percent to ignore a hit.
@export var defense_at_level_one: int = 5
@export var defense_per_level: int = 5

@export_group("Swiftness")
@export var speed_at_level_one: float = 60.0
@export var speed_per_level: float = 10.0
## Endurance gained every endurance_tick; attacking needs max_endurance.
@export var endurance_gain_at_level_one: float = 2.7
@export var endurance_gain_per_level: float = 1.0
@export var max_endurance: int = 10
@export var endurance_tick: float = 0.5

@export_group("Size")
@export var scale_at_level_one: float = 0.5
## Added for every stat level above the first, summed over all stats.
@export var scale_per_level: float = 0.05


func damage(strength: int) -> float:
	return damage_at_level_one + damage_per_level * (strength - 1)


func health(immune: int) -> float:
	return health_at_level_one + health_per_level * (immune - 1)


func defense(immune: int) -> int:
	return defense_at_level_one + defense_per_level * (immune - 1)


func speed(swiftness: int) -> float:
	return speed_at_level_one + speed_per_level * (swiftness - 1)


func endurance_gain(swiftness: int) -> float:
	return endurance_gain_at_level_one + endurance_gain_per_level * (swiftness - 1)


func cell_scale(strength: int, immune: int, swiftness: int) -> Vector2:
	var levels: int = strength - 1 + immune - 1 + swiftness - 1
	return Vector2.ONE * (scale_at_level_one + scale_per_level * levels)
