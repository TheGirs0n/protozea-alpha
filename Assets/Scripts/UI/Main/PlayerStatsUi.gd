extends VBoxContainer
class_name PlayerStatsUi

@export var player_damage_stat_text : RichTextLabel
@export var player_defense_stat_text : RichTextLabel
@export var player_speed_stat_text : RichTextLabel


func set_player_damage_stat(new_value : int):
	player_damage_stat_text.text = str(new_value)
	

func set_player_defense_stat(new_value : int):
	player_defense_stat_text.text = str(new_value)
	
	
func set_player_speed_stat(new_value : int):
	player_speed_stat_text.text = str(new_value)
