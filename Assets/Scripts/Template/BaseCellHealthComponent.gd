@abstract
extends Node
class_name BaseCellHealthComponent

signal health_changed(new_value: float)
signal new_maximum_health(new_max: float)
## The owner cell decides what dying means (its scene connects this to queue_free).
signal cell_died

@export_group("Health Parameters")
@export var cell_passive_health_gain_per_second: float
@export var cell_passive_health_timer: Timer

## Health and defense come from the immune stat (set_cell_health_parameters).
var cell_current_health: float
var cell_max_health: float
var cell_current_defense: int
## Set by AutoBattleHandler; stops passive regeneration during a battle.
var in_battle: bool = false


func set_cell_health_parameters(cell_immune: int, balance: CellBalanceConfig) -> void:
	cell_current_defense = balance.defense(cell_immune)
	cell_max_health = balance.health(cell_immune)
	cell_current_health = cell_max_health
	new_maximum_health.emit(cell_current_health)
	health_changed.emit(cell_current_health)


func try_take_damage(incoming_amount: float) -> void:
	var is_attack_reach: bool = randf_range(0.0, 100.0) > cell_current_defense

	if is_attack_reach:
		reduce_health(incoming_amount)


func reduce_health(amount: float) -> void:
	cell_current_health -= amount
	health_changed.emit(cell_current_health)

	if cell_current_health <= 0:
		cell_current_health = 0
		die()


func restore_health(amount: float) -> void:
	cell_current_health = minf(cell_current_health + amount, cell_max_health)
	health_changed.emit(cell_current_health)


func passive_restore_health() -> void:
	if !in_battle and cell_passive_health_timer != null:
		restore_health(cell_passive_health_gain_per_second)


func die() -> void:
	cell_died.emit()
