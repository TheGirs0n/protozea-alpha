extends Control
class_name PlayerHealthProgressBarUi

@export var player_health_progress_bar : TextureProgressBar

func set_new_value(new_value : int):
	player_health_progress_bar.value = new_value
	
	
func set_new_max(new_max : int):
	player_health_progress_bar.max_value = new_max
