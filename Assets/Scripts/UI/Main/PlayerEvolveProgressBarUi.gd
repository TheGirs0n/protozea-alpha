extends Control
class_name PlayerEvolveProgressBarUi

@export var player_evolve_progress_bar : TextureProgressBar

func set_new_max(new_max : int):
	player_evolve_progress_bar.max_value = new_max
	
	
func set_value(new_value : int):
	player_evolve_progress_bar.value = new_value
	
	
func reset_progress_bar():
	player_evolve_progress_bar.value = 0
