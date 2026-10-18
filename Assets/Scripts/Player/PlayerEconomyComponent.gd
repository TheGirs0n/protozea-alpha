extends Node
class_name PlayerEconomyComponent

signal player_money_changed(new_value: int)

const PLAYER_MAX_MONEY: int = 999

var player_base_money: int = 0
var player_current_money: int


func _ready() -> void:
	player_current_money = player_base_money
	EventBus.money_earned.connect(add_money)


func add_money(amount: int) -> void:
	player_current_money = mini(player_current_money + amount, PLAYER_MAX_MONEY)
	player_money_changed.emit(player_current_money)


## Connected in Player.tscn to PlayerEvolveComponent.player_evolve_money_changed.
func decrease_money(amount: int) -> void:
	player_current_money = maxi(0, player_current_money - amount)
	player_money_changed.emit(player_current_money)


## Connected in PlayerEconomyComponent.tscn to Timer.timeout: re-sends the balance
## so the evolve check and the evolve bar catch up after an evolution or a battle.
func signal_emitter() -> void:
	player_money_changed.emit(player_current_money)
