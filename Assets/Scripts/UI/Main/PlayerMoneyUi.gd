extends HBoxContainer
class_name PlayerMoneyUi

@export var player_money_text : RichTextLabel

func _ready() -> void:
	player_money_text.text = str(0)
	GlobalContext.player_instance.player_economy_component.player_money_changed.connect(set_money)


func set_money(new_amount : int):
	player_money_text.text = str(new_amount)
