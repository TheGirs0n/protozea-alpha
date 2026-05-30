@abstract
extends Node
class_name BaseCellAutoBattleComponent

@export_group("Damage Parameters")
@export var cell_base_damage: float
@export var cell_current_damage: float

@export_group("Endurance Parameters")
@export var cell_base_endurance: float
@export var cell_current_endurance: float
@export var cell_max_endurance: int
@export var cell_gain_per_timer_endurance: float
@export var cell_endurance_timer: Timer

signal endurance_changed(new_value: float)

var is_attack_gain: bool = false
var target_cell: BaseCell


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func _process(_delta: float) -> void:
	if is_attack_gain:
		try_hit_target()
		is_attack_gain = false


func set_cell_strength_parameters(cell_strength: int) -> void:
	cell_current_damage = 1 + (cell_strength - 1) * 0.5


func set_cell_swiftness_parameters(cell_swiftness: int) -> void:
	cell_max_endurance = 10
	cell_endurance_timer.wait_time = 0.5
	cell_gain_per_timer_endurance = 3 - (0.3 - (cell_swiftness - 1))


func try_hit_target() -> void:
	if target_cell and is_instance_valid(target_cell):
		target_cell.cell_health_component.try_take_damage(cell_current_damage)


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
	# FIX: обнуляем ссылку на цель — было висячей ссылкой
	target_cell = null
