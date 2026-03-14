extends BasePlayerEvolveCardUI
class_name PlayerEvolveDamageCardUI

func pick_card():
	GlobalContext.player_instance.player_cell_add_one_strength()
