extends Control
class_name PlayerEvolveProgressBarUi

@export var player_evolve_progress_bar : TextureProgressBar
@export var player_evolve_progress_bar_text : RichTextLabel

func _ready() -> void:
	var economy_comp = GlobalContext.player_instance.player_economy_component
	var evolve_comp = GlobalContext.player_instance.player_evolve_component
	
	economy_comp.player_money_changed.connect(set_value)
	evolve_comp.player_evolve_new_max.connect(set_new_max)
	
	# Явно запрашиваем начальные значения
	set_new_max(evolve_comp.cell_evolve_array_cost[evolve_comp.cell_current_evolve_index])
	set_value(economy_comp.player_current_money)
	

func set_new_max(new_max : int):
	player_evolve_progress_bar.max_value = new_max
	player_evolve_progress_bar_text.text = "" + str(player_evolve_progress_bar.value) + "/" + str(player_evolve_progress_bar.max_value)


func set_value(new_value : int):
	player_evolve_progress_bar.value = new_value
	player_evolve_progress_bar_text.text = "" + str(player_evolve_progress_bar.value) + "/" + str(player_evolve_progress_bar.max_value)
	

func reset_progress_bar():
	player_evolve_progress_bar.value = 0


func signal_emitter():
	if player_evolve_progress_bar.value >= player_evolve_progress_bar.max_value and GlobalContext.main_ui_instance.player_can_evolve_text.visible == false:
		GlobalContext.main_ui_instance.show_evolve_text()
	
