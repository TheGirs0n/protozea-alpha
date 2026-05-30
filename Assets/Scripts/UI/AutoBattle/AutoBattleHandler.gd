extends Node
class_name AutoBattleHandler

## Исправлены:
##   - GlobalContext убран → _enter_tree/_exit_tree удалены
##   - target_cell не обнулялся после боя → висячая ссылка → добавлен target_cell = null
##   - Подписывается на EventBus.battle_requested вместо прямого вызова из BattleAreaContact

var player_cell: BaseCell = null
var enemy_cell: BaseCell = null


func setup() -> void:
	if not EventBus.battle_requested.is_connected(_on_battle_requested):
		EventBus.battle_requested.connect(_on_battle_requested)


func _on_battle_requested(player: BaseCell, enemy: BaseCell) -> void:
	_setup_battle(player, enemy)


func _setup_battle(player: BaseCell, enemy: BaseCell) -> void:
	player_cell = player
	enemy_cell = enemy

	player.cell_movement_component.disable_component()
	enemy.cell_movement_component.disable_component()

	player.cell_health_component.cell_died.connect(_on_player_died)
	enemy.cell_health_component.cell_died.connect(_on_enemy_died)

	player.cell_auto_battle_component.set_target(enemy)
	enemy.cell_auto_battle_component.set_target(player)

	EventBus.battle_started.emit(player, enemy)


func _end_battle() -> void:
	if player_cell:
		if player_cell.cell_health_component.cell_died.is_connected(_on_player_died):
			player_cell.cell_health_component.cell_died.disconnect(_on_player_died)
		player_cell.cell_movement_component.enable_component()

	if enemy_cell:
		if enemy_cell.cell_health_component.cell_died.is_connected(_on_enemy_died):
			enemy_cell.cell_health_component.cell_died.disconnect(_on_enemy_died)
		enemy_cell.cell_movement_component.enable_component()

	EventBus.battle_ended.emit()
	player_cell = null
	enemy_cell = null


func _on_enemy_died() -> void:
	if player_cell:
		player_cell.cell_auto_battle_component.reset_parameters_after_battle()
		# FIX: обнуляем ссылку на цель после боя
		player_cell.cell_auto_battle_component.target_cell = null
	_end_battle()


func _on_player_died() -> void:
	if enemy_cell:
		enemy_cell.cell_auto_battle_component.reset_parameters_after_battle()
		# FIX: обнуляем ссылку на цель после боя
		enemy_cell.cell_auto_battle_component.target_cell = null
	EventBus.player_died.emit()
	_end_battle()
