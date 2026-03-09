extends CanvasLayer
class_name MainUI

@export_group("Main UI")
@export var player_money_container : PlayerMoneyUi
@export var player_stats_ui : PlayerStatsUi
@export var player_health_progress_bar : PlayerHealthProgressBarUi
@export var player_evolve_progress_bar : PlayerEvolveProgressBarUi
@export var player_can_evolve_text : RichTextLabel

@export_group("Auto Battle UI")
@export var auto_battle_ui : AutoBattleUi

@export_group("Evolve Cards Scene")
@export var evolve_cards_scene : PackedScene

@export_group("After Game Screens")
@export var lose_game_screen : PackedScene
@export var win_game_screen : PackedScene


func _ready() -> void:
	GlobalContext.main_ui_instance = self
	GlobalContext.player_instance.player_evolve_component.player_click_evolve.connect(create_evolve_cards)


func create_evolve_cards(player_strength : int, player_immune : int, player_swiftness : int):
	var cards = evolve_cards_scene.instantiate() as PlayerEvolveCardsUI
	
	cards.prepare_cards(player_strength,
	player_immune, 
	player_swiftness)
	
	self.add_child(cards)


func update_player_stats(player_strength : int, player_immune : int, player_swiftness : int):
	player_stats_ui.set_player_damage_stat(player_strength)
	player_stats_ui.set_player_defense_stat(player_immune)
	player_stats_ui.set_player_speed_stat(player_swiftness)


func show_auto_battle_ui():
	pass


func show_lose_game_screen():
	queue_free()


func show_win_game_screen():
	queue_free()


func _exit_tree() -> void:
	GlobalContext.main_ui_instance = null
