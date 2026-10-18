extends Area2D
class_name BattleAreaContact

@export var player: PlayerCell


## Connected in Player.tscn to body_entered.
## Вызов автобаттла при контакте с микробом
func _on_body_entered(body: Node2D) -> void:
	var enemy: EnemyCell = body as EnemyCell
	if enemy == null:
		return

	if player.cell_auto_battle_component.target_cell == null:
		EventBus.battle_requested.emit(player, enemy)
