extends BaseCell
class_name PlayerCell

@export var player_economy_component: PlayerEconomyComponent
@export var player_evolve_component: PlayerEvolveComponent

signal player_cell_stats_check_evolve(stat_sum: int)


func _ready() -> void:
	super._ready()
	_wire_evolve_events()
	

func _wire_evolve_events() -> void:
	# Карточки эволюции эмитят события → PlayerCell реагирует
	EventBus.evolve_strength_requested.connect(player_cell_add_one_strength)
	EventBus.evolve_immune_requested.connect(player_cell_add_one_immune)
	EventBus.evolve_swiftness_requested.connect(player_cell_add_one_swiftness)
	EventBus.evolve_all_requested.connect(_evolve_all)


func _evolve_all() -> void:
	player_cell_add_one_strength()
	player_cell_add_one_immune()
	player_cell_add_one_swiftness()


func player_cell_add_one_strength() -> void:
	set_cell_strength(cell_strength_value + 1)
	set_cell_size_scale()


func player_cell_add_one_immune() -> void:
	set_cell_immune(cell_immune_value + 1)
	set_cell_size_scale()


func player_cell_add_one_swiftness() -> void:
	set_cell_swiftness(cell_swiftness_value + 1)
	set_cell_size_scale()


func ping_ui_update_stats() -> void:
	# FIX: убран прямой вызов GlobalContext.main_ui_instance.update_player_stats()
	EventBus.player_stats_changed.emit(
		cell_strength_value, cell_immune_value, cell_swiftness_value
	)
	var sum := cell_strength_value + cell_immune_value + cell_swiftness_value
	player_cell_stats_check_evolve.emit(sum)
