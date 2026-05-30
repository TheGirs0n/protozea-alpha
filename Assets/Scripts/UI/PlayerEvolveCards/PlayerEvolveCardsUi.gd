extends Control
class_name PlayerEvolveCardsUI

@export var player_damage_evolve_card: PlayerEvolveDamageCardUI
@export var player_defense_evolve_card: PlayerEvolveDefenseCardUI
@export var player_speed_evolve_card: PlayerEvolveSpeedCardUI
@export var player_final_evolve_card: PlayerEvolveFinalCardUI

var _player: PlayerCell = null


func setup(player: PlayerCell) -> void:
	_player = player
	
	player_damage_evolve_card.player_pick_card.connect(player_pick_one_card)
	player_defense_evolve_card.player_pick_card.connect(player_pick_one_card)
	player_speed_evolve_card.player_pick_card.connect(player_pick_one_card)
	player_final_evolve_card.player_pick_card.connect(player_pick_one_card)


func prepare_cards(player_strength: int, player_immune: int, player_swiftness: int) -> void:
	if player_strength == 5 and player_immune == 5 and player_swiftness == 5:
		prepare_final_card()
		return

	if player_strength < 5:
		player_damage_evolve_card.show()
	if player_immune < 5:
		player_defense_evolve_card.show()
	if player_swiftness < 5:
		player_speed_evolve_card.show()


func prepare_final_card() -> void:
	player_final_evolve_card.show()


func player_pick_one_card() -> void:
	if _player:
		_player.player_evolve_component.player_evolve()

	EventBus.player_resume_requested.emit()
	queue_free()
