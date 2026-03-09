extends BaseCellHealthComponent
class_name EnemyCellHealthComponent

signal enemy_cell_eated

func die():
	enemy_cell_eated.emit()
	queue_free()
