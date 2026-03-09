extends BaseCellMovementComponent
class_name PlayerMovementComponent

func _process(_delta: float) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	
func move_cell():
	body_to_move.velocity = direction * cell_current_speed
	body_to_move.move_and_slide()
