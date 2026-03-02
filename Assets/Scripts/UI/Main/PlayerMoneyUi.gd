extends HBoxContainer
class_name PlayerMoneyUi

@export var player_money_text : RichTextLabel

func _ready() -> void:
	player_money_text.text = str(0)

func set_money(new_amount : int):
	player_money_text.text = str(new_amount)
