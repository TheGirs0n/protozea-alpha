extends Node
class_name PlayerEconomyComponent

var player_base_money : int = 0
var player_current_money : int
const player_max_money : int = 999

signal player_money_changed(new_value : int)


func _ready() -> void:
	player_current_money = player_base_money


func add_money(amount : int):
	player_current_money += amount
	
	if player_current_money >= player_max_money:
		player_current_money = player_max_money
	
	player_money_changed.emit(player_current_money)
	

func decrease_money(amount : int):
	player_current_money = max(0, player_current_money - amount)
	
	player_money_changed.emit(player_current_money)


func signal_emmiter():
	player_money_changed.emit(player_current_money)
