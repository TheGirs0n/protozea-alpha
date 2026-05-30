extends BasePlayerEvolveCardUI
class_name PlayerEvolveSpeedCardUI


func pick_card() -> void:
	EventBus.evolve_swiftness_requested.emit()
	player_pick_card.emit()
