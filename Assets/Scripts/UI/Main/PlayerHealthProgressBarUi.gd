extends Control
class_name PlayerHealthProgressBarUi

@export var player_health_progress_bar: TextureProgressBar
@export var player_health_progress_bar_text: RichTextLabel


func setup(player: PlayerCell) -> void:
	var health_comp := player.cell_health_component

	health_comp.health_changed.connect(set_new_value)
	health_comp.new_maximum_health.connect(set_new_max)

	# Устанавливаем начальные значения сразу
	set_new_max(health_comp.cell_max_health)
	set_new_value(health_comp.cell_current_health)


func set_new_value(new_value: float) -> void:
	player_health_progress_bar.value = new_value
	player_health_progress_bar_text.text = (
		str(player_health_progress_bar.value) + "/" + str(player_health_progress_bar.max_value)
	)


func set_new_max(new_max: float) -> void:
	player_health_progress_bar.max_value = new_max
	player_health_progress_bar_text.text = (
		str(player_health_progress_bar.value) + "/" + str(player_health_progress_bar.max_value)
	)
