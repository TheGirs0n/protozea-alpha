extends Control
class_name PlayerEvolveProgressBarUi

@export var player_evolve_progress_bar : TextureProgressBar
@export var player_evolve_progress_bar_text : RichTextLabel

func _ready() -> void:
	GlobalContext.player_instance.player_economy_component.player_money_changed.connect(set_value)
	GlobalContext.player_instance.player_evolve_component.player_evolve_new_max.connect(set_new_max)


func set_new_max(new_max : int):
	player_evolve_progress_bar.max_value = new_max
	player_evolve_progress_bar_text.text = "" + str(player_evolve_progress_bar.value) + "/" + str(player_evolve_progress_bar.max_value)


func set_value(new_value : int):
	player_evolve_progress_bar.value = new_value
	if GlobalContext.main_ui_instance.player_can_evolve_text.visible == false:
		GlobalContext.main_ui_instance.player_can_evolve_text.show()
	
	player_evolve_progress_bar_text.text = "" + str(player_evolve_progress_bar.value) + "/" + str(player_evolve_progress_bar.max_value)


func reset_progress_bar():
	player_evolve_progress_bar.value = 0
