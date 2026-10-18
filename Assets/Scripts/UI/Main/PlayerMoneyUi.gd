extends HBoxContainer
class_name PlayerMoneyUi

@export var player_money_text: RichTextLabel


func setup(player: PlayerCell) -> void:
	set_money(player.player_economy_component.player_current_money)
	player.player_economy_component.player_money_changed.connect(set_money)


func set_money(new_amount: int) -> void:
	player_money_text.text = str(new_amount)
