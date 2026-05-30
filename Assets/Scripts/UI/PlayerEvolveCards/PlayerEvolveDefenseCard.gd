extends BasePlayerEvolveCardUI
class_name PlayerEvolveDefenseCardUI


func pick_card() -> void:
	EventBus.evolve_immune_requested.emit()
	player_pick_card.emit()
