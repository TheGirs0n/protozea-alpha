extends CellBody
class_name SimpleEnemyCell

## Plankton: food without stats, eaten on touch.

@export_group("Simple Enemy Money Parameters")
@export var min_money_value: int = 1
@export var max_money_value: int = 3


## Connected in SimpleEnemy.tscn to Area2D.body_entered.
func _on_body_entered(body: Node2D) -> void:
	if body is PlayerCell:
		EventBus.money_earned.emit(randi_range(min_money_value, max_money_value))
		queue_free()
