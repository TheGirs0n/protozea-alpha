extends Node
class_name PlayerEconomyComponent

var player_base_money: int = 0
var player_current_money: int
const player_max_money: int = 999

signal player_money_changed(new_value: int)


func _ready() -> void:
	player_current_money = player_base_money
	EventBus.money_earned.connect(add_money)


func add_money(amount: int) -> void:
	player_current_money = min(player_current_money + amount, player_max_money)
	player_money_changed.emit(player_current_money)


func decrease_money(amount: int) -> void:
	# FIX: max(0, ...) предотвращает отрицательный баланс
	player_current_money = max(0, player_current_money - amount)
	player_money_changed.emit(player_current_money)


func signal_emitter() -> void:
	player_money_changed.emit(player_current_money)
