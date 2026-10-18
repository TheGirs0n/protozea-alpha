extends Node
class_name PlayerEconomyComponent

signal player_money_changed(new_value: int)

@export var player_base_money: int = 0
@export var player_max_money: int = 999

var player_current_money: int


func _ready() -> void:
	player_current_money = player_base_money
	EventBus.money_earned.connect(add_money)
	player_money_changed.emit(player_current_money)


func add_money(amount: int) -> void:
	player_current_money = mini(player_current_money + amount, player_max_money)
	player_money_changed.emit(player_current_money)


## Connected in Player.tscn to PlayerEvolveComponent.player_evolve_money_changed.
func decrease_money(amount: int) -> void:
	player_current_money = maxi(0, player_current_money - amount)
	player_money_changed.emit(player_current_money)
