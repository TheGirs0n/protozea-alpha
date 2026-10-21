extends Control
class_name PlayerEvolveProgressBarUi

const FINISHED_TEXT_KEY: String = "PLAYER_EVOLVE_OVERALL_TEXT"

@export var player_evolve_progress_bar: TextureProgressBar
@export var player_evolve_progress_bar_text: RichTextLabel

var _is_finished: bool = false


func setup(player: PlayerCell) -> void:
	var economy_comp: PlayerEconomyComponent = player.player_economy_component
	var evolve_comp: PlayerEvolveComponent = player.player_evolve_component

	economy_comp.player_money_changed.connect(set_value)
	evolve_comp.player_evolve_new_max.connect(set_new_max)
	evolve_comp.evolution_finished.connect(_on_evolution_finished)

	set_new_max(evolve_comp.get_current_cost())
	set_value(economy_comp.player_current_money)


func set_new_max(new_max: int) -> void:
	if _is_finished:
		return
	player_evolve_progress_bar.max_value = new_max
	_update_text()


func set_value(new_value: int) -> void:
	if _is_finished:
		return
	player_evolve_progress_bar.value = new_value
	_update_text()


func _update_text() -> void:
	player_evolve_progress_bar_text.text = (
		str(player_evolve_progress_bar.value) + "/" + str(player_evolve_progress_bar.max_value)
	)


func _on_evolution_finished() -> void:
	_is_finished = true
	player_evolve_progress_bar.value = player_evolve_progress_bar.max_value
	player_evolve_progress_bar_text.text = FINISHED_TEXT_KEY
