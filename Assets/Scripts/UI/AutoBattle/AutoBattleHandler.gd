extends Node
class_name AutoBattleHandler

var player_cell : BaseCell = null
var enemy_cell : BaseCell = null

func _enter_tree() -> void:
	GlobalContext.auto_battle_handler_instance = self


func setup_battle_handler(player: BaseCell, enemy: BaseCell) -> void:
	player_cell = player
	enemy_cell = enemy
	
	# Выключить movement component у героев и ... все?
	player.cell_movement_component.disable_component()
	enemy.cell_movement_component.disable_component()
	
	player.cell_health_component.cell_died.connect(_on_player_died)
	enemy.cell_health_component.cell_died.connect(_on_enemy_died)

	player.cell_auto_battle_component.set_target(enemy)
	enemy.cell_auto_battle_component.set_target(player)

	GlobalContext.main_ui_instance.show_auto_battle_ui(player, enemy)


func _end_battle() -> void:
	if player_cell and player_cell.cell_health_component.cell_died.is_connected(_on_player_died):
		player_cell.cell_health_component.cell_died.disconnect(_on_player_died)
		enemy_cell.cell_movement_component.enable_component()
	if enemy_cell and enemy_cell.cell_health_component.cell_died.is_connected(_on_enemy_died):
		enemy_cell.cell_health_component.cell_died.disconnect(_on_enemy_died)
		player_cell.cell_movement_component.enable_component()

	GlobalContext.main_ui_instance.hide_auto_battle_ui()
	player_cell = null
	enemy_cell = null


func _on_enemy_died() -> void:
	player_cell.cell_auto_battle_component.reset_parameters_after_battle()
	_end_battle()


func _on_player_died() -> void:
	enemy_cell.cell_auto_battle_component.reset_parameters_after_battle()
	_end_battle()
	

func _exit_tree() -> void:
	GlobalContext.auto_battle_handler_instance = null
