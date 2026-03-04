extends Control
class_name AutoBattleUi

#@export var player_cell_sprite ?= TextureRect 
#@export var enemy_cell_sprite ?= TextureRect

@export_group("Player Text")
@export var player_damage_text : RichTextLabel
@export var player_defense_text : RichTextLabel
@export var player_endurance_text : RichTextLabel
@export var player_endurance_progress_bar : TextureProgressBar
@export var player_health_progress_bar : TextureProgressBar

@export_group("Enemy Text")
@export var enemy_damage_text : RichTextLabel
@export var enemy_defense_text : RichTextLabel
@export var enemy_endurance_text : RichTextLabel
@export var enemy_endurance_progress_bar : TextureProgressBar
@export var enemy_health_progress_bar : TextureProgressBar

func setup_battle_ui(player : BaseCell, enemy : BaseCell):
	player_damage_text.text = str(player.cell_auto_battle_component.cell_current_damage)
	player_defense_text.text = str(player.cell_health_component.cell_current_defense)
	player_endurance_text.text = str(player.cell_auto_battle_component.cell_current_endurance)
	
	enemy_damage_text.text = str(enemy.cell_auto_battle_component.cell_current_damage)
	enemy_defense_text.text = str(enemy.cell_health_component.cell_current_defense)
	enemy_endurance_text.text = str(enemy.cell_auto_battle_component.cell_current_endurance)
	
	player_endurance_progress_bar.value = 0
	enemy_endurance_progress_bar.value = 0
	
	
func set_player_endurance_new_value(new_value : int):
	player_endurance_progress_bar.value = new_value
	

func set_enemy_endurance_new_value(new_value : int):
	enemy_endurance_progress_bar.value = new_value
