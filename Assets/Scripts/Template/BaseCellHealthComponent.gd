@abstract
extends Node
class_name BaseCellHealthComponent

@export_group("Health Parameters")
@export var cell_current_health : int
@export var cell_max_health : int
@export var cell_passive_health_gain_per_second : int
@export var cell_passive_health_timer : Timer
@export var cell_base_defense : int
@export var cell_current_defense : int


var in_battle : bool = false

func _ready() -> void:
	in_battle = false
	cell_current_health = cell_max_health
	cell_current_defense = cell_base_defense

func try_take_damage(incoming_amount : int):
	var damage = incoming_amount - cell_current_defense
	
	if damage > 0:
		cell_current_defense -= damage
	else:
		return

		
func reduce_health(amount : int):
	cell_current_health -= amount
	
	if cell_current_health > 0:
		cell_current_health -= amount
	else:
		die()

		
func restore_health(amount : int):
	cell_current_health += amount
	
	if cell_current_health >= cell_max_health:
		cell_current_health = cell_max_health
	

func passive_restore_health():
	if !in_battle:
		restore_health(cell_passive_health_gain_per_second)
		
func die():
	queue_free()
