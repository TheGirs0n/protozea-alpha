extends Node
class_name PlayerEvolveComponent

## Decides when the player may evolve and charges for it.
## The evolution is paid on the key press; the cards only choose which stat grows.

signal player_click_evolve()
signal player_evolve_new_max(new_value: int)
signal player_evolve_money_changed(money_amount: int)
signal can_evolve_changed(can_evolve: bool)
signal evolution_finished()

## Cost of each evolution in order; after the last one the evolution is finished.
@export var cell_evolve_array_cost: Array[int]

var cell_current_evolve_index: int = 0
var can_player_evolve_in_current: bool = false
var is_final_evolve: bool = false

var _money: int = 0
var _is_in_battle: bool = false


func _ready() -> void:
	# Choosing a card pauses the player, so it is not allowed mid-fight
	EventBus.battle_started.connect(_on_battle_started)
	EventBus.battle_ended.connect(_on_battle_ended)
	player_evolve_new_max.emit(get_current_cost())


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"try_evolve") and can_player_evolve_in_current:
		player_click_evolve.emit()


## Cost of the next evolution. Only meaningful while is_final_evolve is false.
func get_current_cost() -> int:
	return cell_evolve_array_cost[cell_current_evolve_index]


## Connected in Player.tscn to player_click_evolve.
func player_evolve() -> void:
	var cost: int = get_current_cost()
	cell_current_evolve_index += 1
	if cell_current_evolve_index >= cell_evolve_array_cost.size():
		finish_evolution()
	else:
		player_evolve_new_max.emit(get_current_cost())
	# Charge after moving to the next cost so the money update re-checks against it
	player_evolve_money_changed.emit(cost)


## Connected in Player.tscn to PlayerEconomyComponent.player_money_changed.
func can_player_evolve_current(new_money: int) -> void:
	_money = new_money
	_update_can_evolve()


## Called by PlayerCell when the final card has been taken.
func finish_evolution() -> void:
	if is_final_evolve:
		return
	is_final_evolve = true
	evolution_finished.emit()
	_update_can_evolve()


func _on_battle_started(_player: BaseCell, _enemy: BaseCell) -> void:
	_is_in_battle = true
	_update_can_evolve()


func _on_battle_ended() -> void:
	_is_in_battle = false
	_update_can_evolve()


func _update_can_evolve() -> void:
	var can_evolve: bool = (
		not is_final_evolve and not _is_in_battle and _money >= get_current_cost()
	)
	if can_evolve == can_player_evolve_in_current:
		return
	can_player_evolve_in_current = can_evolve
	can_evolve_changed.emit(can_evolve)
