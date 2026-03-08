extends Area2D
class_name SimpleEnemyCell

@export_group("Simple Enemy Money Parameters")
@export var min_money_value : int = 1
@export var max_money_value : int = 3


func _on_body_entered(body: Node2D) -> void:
	if body is PlayerCell:
		body.player_economy_component.add_money(randi_range(min_money_value, max_money_value))
		queue_free()
