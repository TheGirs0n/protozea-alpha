extends CanvasLayer
class_name MainUI

@export_group("Main UI")
@export var player_money_container: PlayerMoneyUi
@export var player_stats_ui: PlayerStatsUi
@export var player_health_progress_bar: PlayerHealthProgressBarUi
@export var player_evolve_progress_bar: PlayerEvolveProgressBarUi
@export var player_can_evolve_text: RichTextLabel
@export var eaten_counter_text: RichTextLabel
@export var pause_ui: PauseMenu

@export_group("Auto Battle UI")
@export var auto_battle_ui: AutoBattleUi

@export_group("Evolve Cards Scene")
@export var evolve_cards_scene: PackedScene

@export_group("After Game Screens")
@export var lose_game_screen: PackedScene
@export var win_game_screen: PackedScene

var is_autobattle_ui_active: bool = false

var _player: PlayerCell = null
var _is_evolve_cards_open: bool = false
var _eaten: int = 0
var _eaten_goal: int = 0


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED and _player != null:
		_update_texts()


func setup(player: PlayerCell, predators_to_win: int) -> void:
	_player = player
	_eaten_goal = predators_to_win

	player_health_progress_bar.setup(player)
	player_evolve_progress_bar.setup(player)
	player_money_container.setup(player)

	update_player_stats(
		player.cell_strength_value,
		player.cell_immune_value,
		player.cell_swiftness_value
	)

	player.player_evolve_component.player_click_evolve.connect(create_evolve_cards)
	player.player_evolve_component.can_evolve_changed.connect(_on_can_evolve_changed)

	EventBus.player_stats_changed.connect(update_player_stats)
	EventBus.battle_started.connect(show_auto_battle_ui)
	EventBus.battle_ended.connect(hide_auto_battle_ui)
	EventBus.game_won.connect(show_win_game_screen)
	EventBus.player_died.connect(show_lose_game_screen)
	EventBus.predator_eaten.connect(_on_predator_eaten)
	EventBus.player_resume_requested.connect(_on_evolve_cards_closed)

	_update_texts()
	_refresh_evolve_text()


func create_evolve_cards() -> void:
	var cards: PlayerEvolveCardsUI = evolve_cards_scene.instantiate() as PlayerEvolveCardsUI
	cards.prepare_cards(_player)
	add_child(cards)
	_is_evolve_cards_open = true
	_refresh_evolve_text()


func update_player_stats(player_strength: int, player_immune: int, player_swiftness: int) -> void:
	player_stats_ui.set_player_damage_stat(player_strength)
	player_stats_ui.set_player_defense_stat(player_immune)
	player_stats_ui.set_player_speed_stat(player_swiftness)


func show_auto_battle_ui(player: BaseCell, enemy: BaseCell) -> void:
	auto_battle_ui.setup_battle_ui(player, enemy)
	player_health_progress_bar.hide()
	player_evolve_progress_bar.hide()
	is_autobattle_ui_active = true
	_refresh_evolve_text()


func hide_auto_battle_ui() -> void:
	auto_battle_ui.hide_battle_ui()
	player_health_progress_bar.show()
	player_evolve_progress_bar.show()
	is_autobattle_ui_active = false
	_refresh_evolve_text()


func show_lose_game_screen() -> void:
	get_tree().change_scene_to_packed(lose_game_screen)


func show_win_game_screen() -> void:
	get_tree().change_scene_to_packed(win_game_screen)


func show_pause() -> void:
	pause_ui.show()


func hide_pause() -> void:
	pause_ui.hide()


func _on_can_evolve_changed(_can_evolve: bool) -> void:
	_refresh_evolve_text()


func _on_predator_eaten(eaten: int, goal: int) -> void:
	_eaten = eaten
	_eaten_goal = goal
	_update_texts()


## Texts built from translation templates; refreshed when the language changes.
func _update_texts() -> void:
	eaten_counter_text.text = tr("PREDATORS_EATEN") % [_eaten, _eaten_goal]
	player_can_evolve_text.text = tr("PLAYER_EVOLVE_HINT") % InputHints.first_key(&"try_evolve")


## The cards emit player_resume_requested when one of them is picked.
func _on_evolve_cards_closed() -> void:
	_is_evolve_cards_open = false
	_refresh_evolve_text()


## The hint is shown only when the player can act on it right now.
func _refresh_evolve_text() -> void:
	player_can_evolve_text.visible = (
		_player.player_evolve_component.can_player_evolve_in_current
		and not is_autobattle_ui_active
		and not _is_evolve_cards_open
	)
