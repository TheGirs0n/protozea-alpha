extends CanvasLayer
class_name MainUI

@export_group("Main UI")
@export var player_money_container : PlayerMoneyUi
@export var player_stats_ui : PlayerStatsUi
@export var player_evolve_progress_bar : PlayerEvolveProgressBarUi
@export var player_can_evolve_text : RichTextLabel
@export var player_health_progress_bar : PlayerHealthProgressBarUi

@export_group("Auto Battle UI")
@export var auto_battle_ui : AutoBattleUi

@export_group("Evolve Cards Scene")
@export var evolve_cards_scene : PackedScene

func _ready() -> void:
	GlobalContext.main_ui_instance = self
	GlobalContext.player_instance.player_evolve_component.player_click_evolve.connect(create_evolve_cards)


func create_evolve_cards():
	var cards = evolve_cards_scene.instantiate() as PlayerEvolveCardsUI
	
	cards.prepare_cards(GlobalContext.player_instance.cell_strength_value,
	GlobalContext.player_instance.cell_immune_value, 
	GlobalContext.player_instance.cell_swiftness_value)
	
	self.add_child(cards)


func update_player_stats(player_strength : int, player_immune : int, player_swiftness : int):
	player_stats_ui.set_player_damage_stat(player_strength)
	player_stats_ui.set_player_defense_stat(player_immune)
	player_stats_ui.set_player_speed_stat(player_swiftness)


func _exit_tree() -> void:
	GlobalContext.main_ui_instance = null
