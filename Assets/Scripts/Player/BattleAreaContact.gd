extends Area2D
class_name BattleAreaContact

# Вызов автобаттла при контакте с микробом
func _on_body_entered(enemy_cell: Node2D) -> void:
	if enemy_cell is EnemyCell:
		GlobalContext.auto_battle_handler_instance.setup_battle_handler(get_parent(), enemy_cell)
