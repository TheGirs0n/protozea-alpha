extends CanvasLayer
class_name MainUI

@export_group("Main UI")
@export var player_money_container: PlayerMoneyUi
@export var player_stats_ui: PlayerStatsUi
@export var player_health_progress_bar: PlayerHealthProgressBarUi
@export var player_evolve_progress_bar: PlayerEvolveProgressBarUi
@export var player_can_evolve_text: RichTextLabel
@export var pause_ui: PauseMenu

@export_group("Auto Battle UI")
@export var auto_battle_ui: AutoBattleUi

@export_group("Evolve Cards Scene")
@export var evolve_cards_scene: PackedScene

@export_group("After Game Screens")
@export var lose_game_screen: PackedScene
@export var win_game_screen: PackedScene

var _player: PlayerCell = null
var is_autobattle_ui_active: bool = false


func setup(player: PlayerCell) -> void:
	_player = player

	player_health_progress_bar.setup(player)
	player_evolve_progress_bar.setup(player)
	player_money_container.setup(player)

	update_player_stats(
		player.cell_strength_value,
		player.cell_immune_value,
		player.cell_swiftness_value
	)

	player.player_evolve_component.player_click_evolve.connect(create_evolve_cards)

	EventBus.player_stats_changed.connect(update_player_stats)
	EventBus.battle_started.connect(show_auto_battle_ui)
	EventBus.battle_ended.connect(hide_auto_battle_ui)
	EventBus.all_enemies_cleared.connect(show_win_game_screen)
	EventBus.player_died.connect(show_lose_game_screen)
	EventBus.show_evolve_text_requested.connect(show_evolve_text)


func create_evolve_cards() -> void:
	var cards := evolve_cards_scene.instantiate() as PlayerEvolveCardsUI
	cards.prepare_cards(
		_player.cell_strength_value,
		_player.cell_immune_value,
		_player.cell_swiftness_value
	)
	cards.setup(_player)
	add_child(cards)
	player_can_evolve_text.hide()


func update_player_stats(player_strength: int, player_immune: int, player_swiftness: int) -> void:
	player_stats_ui.set_player_damage_stat(player_strength)
	player_stats_ui.set_player_defense_stat(player_immune)
	player_stats_ui.set_player_speed_stat(player_swiftness)


func show_auto_battle_ui(player: BaseCell, enemy: BaseCell) -> void:
	auto_battle_ui.setup_battle_ui(player, enemy)
	player_health_progress_bar.hide()
	player_evolve_progress_bar.hide()
	player_can_evolve_text.hide()
	is_autobattle_ui_active = true


func hide_auto_battle_ui() -> void:
	auto_battle_ui.hide_battle_ui()
	player_health_progress_bar.show()
	player_evolve_progress_bar.show()
	is_autobattle_ui_active = false


func show_evolve_text() -> void:
	if not is_autobattle_ui_active:
		player_can_evolve_text.show()


func show_lose_game_screen() -> void:
	var scene := lose_game_screen.instantiate()
	get_tree().root.add_child(scene)
	queue_free()


func show_win_game_screen() -> void:
	var scene := win_game_screen.instantiate()
	get_tree().root.add_child(scene)
	queue_free()


func show_pause() -> void:
	pause_ui.show()


func hide_pause() -> void:
	pause_ui.hide()
