extends Control
class_name PlayerEvolveProgressBarUi

@export var player_evolve_progress_bar: TextureProgressBar
@export var player_evolve_progress_bar_text: RichTextLabel


func setup(player: PlayerCell) -> void:
	var economy_comp := player.player_economy_component
	var evolve_comp := player.player_evolve_component

	economy_comp.player_money_changed.connect(set_value)
	evolve_comp.player_evolve_new_max.connect(set_new_max)

	set_new_max(evolve_comp.cell_evolve_array_cost[evolve_comp.cell_current_evolve_index])
	set_value(economy_comp.player_current_money)


func set_new_max(new_max: int) -> void:
	player_evolve_progress_bar.max_value = new_max
	_update_text()


func set_value(new_value: int) -> void:
	player_evolve_progress_bar.value = new_value
	_update_text()
	_check_can_evolve()


func reset_progress_bar() -> void:
	player_evolve_progress_bar.value = 0
	_update_text()


func _update_text() -> void:
	player_evolve_progress_bar_text.text = (
		str(player_evolve_progress_bar.value) + "/" + str(player_evolve_progress_bar.max_value)
	)


func _check_can_evolve() -> void:
	if player_evolve_progress_bar.value >= player_evolve_progress_bar.max_value:
		EventBus.show_evolve_text_requested.emit()
