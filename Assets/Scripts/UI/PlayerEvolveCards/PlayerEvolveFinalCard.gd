extends BasePlayerEvolveCardUI
class_name PlayerEvolveFinalCardUI

func pick_card():
	GlobalContext.player_instance.player_cell_add_one_strength()
	GlobalContext.player_instance.player_cell_add_one_immune()
	GlobalContext.player_instance.player_cell_add_one_swiftness()
	player_pick_card.emit()
