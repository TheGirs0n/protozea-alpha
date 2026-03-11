extends Control
class_name PlayerHealthProgressBarUi

@export var player_health_progress_bar : TextureProgressBar
@export var player_health_progress_bar_text : RichTextLabel


func _ready() -> void:
	GlobalContext.player_instance.cell_health_component.health_changed.connect(set_new_value)
	GlobalContext.player_instance.cell_health_component.new_maximum_health.connect(set_new_max)

func set_new_value(new_value : float):
	player_health_progress_bar.value = new_value
	player_health_progress_bar_text.text = str(player_health_progress_bar.value) + "/" + str(player_health_progress_bar.max_value)
	
	
func set_new_max(new_max : float):
	player_health_progress_bar.max_value = new_max
	player_health_progress_bar_text.text = str(player_health_progress_bar.value) + "/" + str(player_health_progress_bar.max_value)
