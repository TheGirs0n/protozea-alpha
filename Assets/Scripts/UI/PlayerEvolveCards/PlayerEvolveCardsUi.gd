extends Control
class_name PlayerEvolveCardsUI

@export var player_damage_evolve_card : PlayerEvolveDamageCardUI
@export var player_defense_evolve_card : PlayerEvolveDefenseCardUI
@export var player_speed_evolve_card : PlayerEvolveSpeedCardUI
@export var player_final_evolve_card : PlayerEvolveFinalCardUI

func prepare_cards(player_strength : int, player_immune : int, player_swiftness : int):
	if player_strength == 5 and player_immune == 5 and player_swiftness == 5:
		prepare_final_card()
		return
	
	if player_strength < 5:
		player_damage_evolve_card.show()
	if player_immune < 5:
		player_defense_evolve_card.show()
	if player_swiftness < 5:
		player_speed_evolve_card.show()
		

func prepare_final_card():
	player_final_evolve_card.show()


func player_pick_one_card():
	GlobalContext.main_scene_instance.continue_player()
	queue_free()
