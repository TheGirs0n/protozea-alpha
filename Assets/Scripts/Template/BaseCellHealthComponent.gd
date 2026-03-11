@abstract
extends Node
class_name BaseCellHealthComponent

@export_group("Health Parameters")
@export var cell_current_health : float
@export var cell_max_health : float
@export var cell_passive_health_gain_per_second : float
@export var cell_passive_health_timer : Timer
@export var cell_base_defense : int
@export var cell_current_defense : int

signal health_changed(new_value: float)
signal new_maximum_health(new_max : int)
signal cell_died

var in_battle : bool = false


func _ready() -> void:
	in_battle = false
	cell_current_health = cell_max_health
	cell_current_defense = cell_base_defense
	

func set_cell_health_parameters(cell_immune : int):
	cell_current_defense = cell_immune * 5
	cell_max_health = 5 + 2 * (cell_immune - 1)
	cell_current_health = cell_max_health
	health_changed.emit(cell_current_health)
	new_maximum_health.emit(cell_current_health)
	

func try_take_damage(incoming_amount: float) -> void:
	var is_attack_reach : bool = true if randf_range(0, 100) > cell_current_defense else false

	if is_attack_reach:
		reduce_health(incoming_amount)

		
func reduce_health(amount: float) -> void:
	cell_current_health -= amount
	health_changed.emit(cell_current_health)

	if cell_current_health <= 0:
		cell_current_health = 0
		die()

		
func restore_health(amount: float) -> void:
	cell_current_health = min(cell_current_health + amount, cell_max_health)
	health_changed.emit(cell_current_health)
	

func passive_restore_health():
	if !in_battle and cell_passive_health_timer != null:
		restore_health(cell_passive_health_gain_per_second)
	
		
func die():
	cell_died.emit()
	get_parent().queue_free()
