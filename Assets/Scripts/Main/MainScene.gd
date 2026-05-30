extends Node
class_name MainScene

## Composition Root — единственное место, где все узлы знают друг о друге.
## Удалены: GlobalContext.main_scene_instance = self / null

@export var main_level: MainLevel
@export var main_ui: MainUI
@onready var player: PlayerCell = $MainLevel/Player
@onready var enemy_manager: EnemyManager = $MainLevel/EnemyManager
@onready var auto_battle_handler: AutoBattleHandler = $MainLevel/AutoBattleHandler


func _ready() -> void:
	_wire_dependencies()
	_wire_events()


func _wire_dependencies() -> void:
	# Каждый узел получает только нужные ему зависимости
	enemy_manager.setup(player)
	auto_battle_handler.setup()
	main_ui.setup(player)
	main_level.setup()


func _wire_events() -> void:
	if not EventBus.continue_requested.is_connected(continue_game):
		EventBus.continue_requested.connect(continue_game)
	if not EventBus.go_to_main_menu_requested.is_connected(queue_free):
		EventBus.go_to_main_menu_requested.connect(queue_free)
	if not EventBus.player_resume_requested.is_connected(continue_player):
		EventBus.player_resume_requested.connect(continue_player)
	if not player.player_evolve_component.player_click_evolve.is_connected(pause_player):
		player.player_evolve_component.player_click_evolve.connect(pause_player)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game"):
		pause_game()


func pause_player() -> void:
	player.process_mode = Node.PROCESS_MODE_DISABLED


func pause_game() -> void:
	main_level.process_mode = Node.PROCESS_MODE_DISABLED
	main_ui.show_pause()


func continue_game() -> void:
	main_level.process_mode = Node.PROCESS_MODE_INHERIT
	main_ui.hide_pause()


func continue_player() -> void:
	player.process_mode = Node.PROCESS_MODE_INHERIT
