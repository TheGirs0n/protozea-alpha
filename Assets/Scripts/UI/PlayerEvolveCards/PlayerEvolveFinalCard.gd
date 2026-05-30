extends BasePlayerEvolveCardUI
class_name PlayerEvolveFinalCardUI


func pick_card() -> void:
	EventBus.evolve_all_requested.emit()
	player_pick_card.emit()
