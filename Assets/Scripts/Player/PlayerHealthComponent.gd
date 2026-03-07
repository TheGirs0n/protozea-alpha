extends BaseCellHealthComponent
class_name PlayerHealthComponent

func reduce_health(amount : float):
	cell_current_health -= amount
	
	if cell_current_health > 0:
		cell_current_health -= amount
		GlobalContext.main_ui_instance.player_health_progress_bar.set_new_value(cell_current_health)
	else:
		cell_current_health = 0
		GlobalContext.main_ui_instance.player_health_progress_bar.set_new_value(cell_current_health)
		die()
	
	
func restore_health(amount : float):
	cell_current_health += amount
	
	if cell_current_health >= cell_max_health:
		cell_current_health = cell_max_health
		
	GlobalContext.main_ui_instance.player_health_progress_bar.set_new_value(cell_current_health)
		
		
func die():
	queue_free()
