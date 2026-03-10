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

var in_battle : bool = false
signal health_changed(new_value: float)
signal cell_died


func _ready() -> void:
	in_battle = false
	cell_current_health = cell_max_health
	cell_current_defense = cell_base_defense


func try_take_damage(incoming_amount: float) -> void:
	var damage = incoming_amount - cell_current_defense

	if damage <= 0:
		return

	cell_current_health -= damage
	health_changed.emit(cell_current_health)  # UI обновляется

	if cell_current_health <= 0:
		cell_current_health = 0
		die()

		
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
	queue_free()
