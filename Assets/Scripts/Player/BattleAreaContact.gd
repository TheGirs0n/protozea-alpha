extends Area2D
class_name BattleAreaContact

signal on_player_enter_enemy

# Вызов автобаттла при контакте с микробом
func _on_body_entered(enemy: Node2D) -> void:
	if enemy is BaseCell:
		on_player_enter_enemy.emit()
