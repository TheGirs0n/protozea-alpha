@abstract
extends Node
class_name BaseCellAutoBattleComponent

signal endurance_changed(new_value: float)

@export_group("Damage Parameters")
@export var cell_base_damage: float
@export var cell_current_damage: float

@export_group("Endurance Parameters")
@export var cell_base_endurance: float
@export var cell_current_endurance: float
@export var cell_max_endurance: int
@export var cell_gain_per_timer_endurance: float
@export var cell_endurance_timer: Timer

var is_attack_gain: bool = false
var target_cell: BaseCell


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func _process(_delta: float) -> void:
	if is_attack_gain:
		try_hit_target()
		is_attack_gain = false


func set_cell_strength_parameters(cell_strength: int, balance: CellBalanceConfig) -> void:
	cell_current_damage = balance.damage(cell_strength)


func set_cell_swiftness_parameters(cell_swiftness: int, balance: CellBalanceConfig) -> void:
	cell_max_endurance = balance.max_endurance
	cell_endurance_timer.wait_time = balance.endurance_tick
	cell_gain_per_timer_endurance = balance.endurance_gain(cell_swiftness)


func try_hit_target() -> void:
	if is_instance_valid(target_cell):
		target_cell.cell_health_component.try_take_damage(cell_current_damage)


## Connected in the auto battle component scenes to Timer.timeout.
func restore_endurance() -> void:
	cell_current_endurance += cell_gain_per_timer_endurance

	if cell_current_endurance >= cell_max_endurance:
		cell_current_endurance = cell_max_endurance
		endurance_changed.emit(cell_current_endurance)
		is_attack_gain = true
		cell_current_endurance = 0

	endurance_changed.emit(cell_current_endurance)


func set_target(target: BaseCell) -> void:
	target_cell = target
	process_mode = Node.PROCESS_MODE_INHERIT
	cell_endurance_timer.start()


func reset_parameters_after_battle() -> void:
	cell_current_endurance = 0
	cell_endurance_timer.stop()
	is_attack_gain = false
	process_mode = Node.PROCESS_MODE_DISABLED
	endurance_changed.emit(0)
	target_cell = null
