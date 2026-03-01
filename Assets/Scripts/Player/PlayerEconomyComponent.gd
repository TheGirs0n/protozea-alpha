extends Node
class_name PlayerEconomyComponent

var player_base_money : int = 0
var player_current_money : int
const player_max_money : int = 999

func _ready() -> void:
	player_current_money = player_base_money


func can_buy_passive() -> bool:
	return true


func add_money(amount : int):
	player_current_money += amount
	
	if player_current_money >= player_max_money:
		player_current_money = player_max_money

		
func decrease_money(amount : int):
	player_current_money -= amount
