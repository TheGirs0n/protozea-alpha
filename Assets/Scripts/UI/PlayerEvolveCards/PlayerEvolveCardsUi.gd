extends Control
class_name PlayerEvolveCardsUI

@export var player_damage_evolve_card: PlayerEvolveDamageCardUI
@export var player_defense_evolve_card: PlayerEvolveDefenseCardUI
@export var player_speed_evolve_card: PlayerEvolveSpeedCardUI
@export var player_final_evolve_card: PlayerEvolveFinalCardUI


## Shows a card for every stat below the cap, or the final card when all are capped.
func prepare_cards(player: PlayerCell) -> void:
	var max_stat: int = player.cell_balance.max_stat
	var can_raise_strength: bool = player.cell_strength_value < max_stat
	var can_raise_immune: bool = player.cell_immune_value < max_stat
	var can_raise_swiftness: bool = player.cell_swiftness_value < max_stat

	if not can_raise_strength and not can_raise_immune and not can_raise_swiftness:
		prepare_final_card()
		return

	player_damage_evolve_card.visible = can_raise_strength
	player_defense_evolve_card.visible = can_raise_immune
	player_speed_evolve_card.visible = can_raise_swiftness


func prepare_final_card() -> void:
	player_final_evolve_card.show()


## Connected in PlayerEvolveCardsUI.tscn to every card's player_pick_card.
## The evolution itself is paid on the key press
## (Player.tscn: player_click_evolve -> player_evolve).
func player_pick_one_card() -> void:
	EventBus.player_resume_requested.emit()
	queue_free()
