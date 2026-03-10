@abstract
extends Node
class_name BaseCellAutoBattleComponent

@export_group("Damage Parameters")
@export var cell_base_damage : float
@export var cell_current_damage : float

@export_group("Endurance Parameters")
@export var cell_base_endurance : float
@export var cell_current_endurance : float
@export var cell_max_endurance : int
@export var cell_gain_per_timer_endurance : float
@export var cell_endurance_timer : Timer

signal endurance_changed(new_value: float)

var is_attack_gain : bool = false
var target_cell : BaseCell

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

func _process(_delta: float) -> void:
	if is_attack_gain:
		try_hit_target()
		is_attack_gain = false


func try_hit_target():
	target_cell.cell_health_component.try_take_damage(cell_current_damage)
	

func restore_endurance():
	cell_current_endurance += cell_gain_per_timer_endurance
	
	if cell_current_endurance >= cell_max_endurance:
		cell_current_endurance = cell_max_endurance
		endurance_changed.emit(cell_current_endurance)
		is_attack_gain = true
		cell_current_endurance = 0

	endurance_changed.emit(cell_current_endurance)

# По сути обьявление битвы
func set_target(target : BaseCell): 
	target_cell = target
	process_mode = Node.PROCESS_MODE_INHERIT
	cell_endurance_timer.start()


func reset_parameters_after_battle():
	cell_current_endurance = 0
	cell_endurance_timer.stop()
	is_attack_gain = false
	process_mode = Node.PROCESS_MODE_DISABLED
	endurance_changed.emit(0)
