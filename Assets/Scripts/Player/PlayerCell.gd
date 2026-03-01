extends BaseCell
class_name PlayerCell

@export var player_economy_component : PlayerEconomyComponent
@export var player_evolve_component : PlayerEvolveComponent

func _ready() -> void:
	GlobalContext.player_instance = self
	
func _exit_tree() -> void:
	GlobalContext.player_instance = null
