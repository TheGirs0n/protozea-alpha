@abstract
extends CellBody
class_name BaseCell

## A cell with stats that can fight: health and auto battle on top of CellBody.

signal cell_stats_changed

const SIZE_TWEEN_DURATION: float = 0.25

@export_group("Battle Components")
@export var cell_health_component: BaseCellHealthComponent
@export var cell_auto_battle_component: BaseCellAutoBattleComponent

@export_group("Resource")
@export var cell_start_stats_resource: CellStartStatResource
@export var cell_balance: CellBalanceConfig = preload(
	"res://Assets/Resources/CellResources/CellBalance.tres"
)

var cell_strength_value: int = 0
var cell_immune_value: int = 0
var cell_swiftness_value: int = 0

var size_tween: Tween


func _ready() -> void:
	scale = Vector2.ONE * cell_balance.scale_at_level_one
	set_base_stat()


func set_base_stat() -> void:
	set_cell_strength(cell_start_stats_resource.cell_base_strength)
	set_cell_immune(cell_start_stats_resource.cell_base_immune)
	set_cell_swiftness(cell_start_stats_resource.cell_base_swiftness)
	set_cell_size_scale()


func set_cell_strength(new_value: int) -> void:
	cell_strength_value = new_value

	cell_auto_battle_component.set_cell_strength_parameters(cell_strength_value, cell_balance)
	cell_stats_changed.emit()


func set_cell_immune(new_value: int) -> void:
	cell_immune_value = new_value

	cell_health_component.set_cell_health_parameters(cell_immune_value, cell_balance)
	cell_stats_changed.emit()


func set_cell_swiftness(new_value: int) -> void:
	cell_swiftness_value = new_value

	cell_movement_component.set_cell_move_speed(cell_swiftness_value, cell_balance)
	cell_auto_battle_component.set_cell_swiftness_parameters(cell_swiftness_value, cell_balance)
	cell_stats_changed.emit()


func set_cell_size_scale() -> void:
	var new_scale: Vector2 = cell_balance.cell_scale(
		cell_strength_value, cell_immune_value, cell_swiftness_value
	)

	if size_tween:
		size_tween.kill()

	size_tween = create_tween()
	size_tween.set_ease(Tween.EASE_OUT)
	size_tween.set_trans(Tween.TRANS_QUAD)
	size_tween.tween_property(self, "scale", new_scale, SIZE_TWEEN_DURATION)
