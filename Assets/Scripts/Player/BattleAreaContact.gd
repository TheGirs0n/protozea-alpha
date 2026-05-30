extends Area2D
class_name BattleAreaContact

# Вызов автобаттла при контакте с микробом
func _on_body_entered(enemy_cell: Node2D) -> void:
	var player := get_parent() as PlayerCell
	if player == null:
		return

	if enemy_cell is EnemyCell and player.cell_auto_battle_component.target_cell == null:
		EventBus.battle_requested.emit(player, enemy_cell)
