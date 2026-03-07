extends Control
class_name PlayerEvolveProgressBarUi

@export var player_evolve_progress_bar : TextureProgressBar

func _ready() -> void:
	GlobalContext.player_instance.player_economy_component.player_money_changed.connect(set_value)


func set_new_max(new_max : int):
	player_evolve_progress_bar.max_value = new_max
	

func set_value(new_value : int):
	if player_evolve_progress_bar.value == player_evolve_progress_bar.max_value:
		if GlobalContext.main_ui_instance.player_can_evolve_text.visible == true:
			return
		else:
			GlobalContext.main_ui_instance.player_can_evolve_text.show()
	else:
		player_evolve_progress_bar.value = new_value
	

func reset_progress_bar():
	player_evolve_progress_bar.value = 0
