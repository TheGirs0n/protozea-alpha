extends BaseCellMovementComponent
class_name PlayerMovementComponent

func _process(_delta: float) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	
func move_cell():
	var delta = get_physics_process_delta_time()
	var dir_angle = direction.angle()
	
	if direction != Vector2.ZERO:
		body_to_move.cell_animated_sprite_component.rotation = lerp_angle(body_to_move.cell_animated_sprite_component.rotation, dir_angle, 5.0 * delta)
	
	body_to_move.velocity = direction * cell_current_speed
	body_to_move.move_and_slide()
	GlobalContext.main_ui_instance.move_main_background(direction)
