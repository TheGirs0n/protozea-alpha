extends Node
class_name AutoBattleHandler

var player_cell : BaseCell = null
var enemy_cell : BaseCell = null

var is_enemy_dead : bool = false

func setup_battle_handler(player : BaseCell, enemy : BaseCell):
	player_cell = player
	enemy_cell = enemy
	
	player.cell_auto_battle_component.set_target(enemy_cell)
	enemy.cell_auto_battle_component.set_target(player_cell)


func check_battle_status():
	if is_enemy_dead:
		pass
	else:
		pass
