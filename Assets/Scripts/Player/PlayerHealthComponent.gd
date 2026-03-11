extends BaseCellHealthComponent
class_name PlayerHealthComponent

func reduce_health(amount: float) -> void:
	cell_current_health -= amount
	health_changed.emit(cell_current_health)

	if cell_current_health <= 0:
		cell_current_health = 0
		die()
	
	
func restore_health(amount : float):
	cell_current_health = min(cell_current_health + amount, cell_max_health)
	health_changed.emit(cell_current_health)
