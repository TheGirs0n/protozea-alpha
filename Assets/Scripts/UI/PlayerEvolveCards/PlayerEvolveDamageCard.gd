extends BasePlayerEvolveCardUI
class_name PlayerEvolveDamageCardUI


func pick_card() -> void:
	EventBus.evolve_strength_requested.emit()
	player_pick_card.emit()
