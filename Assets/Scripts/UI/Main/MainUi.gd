extends CanvasLayer
class_name MainUI

@export_group("Main UI")
@export var player_money_container : PlayerMoneyUi
@export var player_stats_ui : PlayerStatsUi
@export var player_evolve_progress_bar : PlayerEvolveProgressBarUi
@export var player_health_progress_bar : PlayerHealthProgressBarUi

@export_group("Auto Battle UI")
@export var auto_battle_ui : AutoBattleUi


func _ready() -> void:
	GlobalContext.main_ui_instance = self


func _exit_tree() -> void:
	GlobalContext.main_ui_instance = null
