extends Area2D
class_name BattleAreaContact

@export var player: PlayerCell


func _ready() -> void:
	EventBus.battle_ended.connect(_on_battle_ended)


## Connected in Player.tscn to body_entered.
## Вызов автобаттла при контакте с микробом
func _on_body_entered(body: Node2D) -> void:
	var enemy: EnemyCell = body as EnemyCell
	if enemy == null or enemy.is_queued_for_deletion():
		return

	if player.cell_auto_battle_component.target_cell == null:
		EventBus.battle_requested.emit(player, enemy)


func _on_battle_ended() -> void:
	if player.is_queued_for_deletion():
		return
	# A cell that came in during the fight never fires body_entered again
	_start_battle_with_overlapping.call_deferred()


func _start_battle_with_overlapping() -> void:
	if not is_inside_tree():
		return
	for body: Node2D in get_overlapping_bodies():
		_on_body_entered(body)
