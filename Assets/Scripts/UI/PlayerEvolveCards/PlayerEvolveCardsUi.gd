extends Control
class_name PlayerEvolveCardsUI

@export var player_damage_evolve_card : PlayerEvolveDamageCardUI
@export var player_defense_evolve_card : PlayerEvolveDefenseCardUI
@export var player_speed_evolve_card : PlayerEvolveSpeedCardUI

func prepare_cards(player_strength : int, player_immune : int, player_swiftness : int):
	if player_strength > 5:
		player_damage_evolve_card.hide()
	
	if player_immune > 5:
		player_defense_evolve_card.hide()
		
	if player_swiftness > 5:
		player_speed_evolve_card.hide()
