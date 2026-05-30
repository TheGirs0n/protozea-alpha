extends Node2D
class_name MainLevel

@export_group("Background Texture Parallax Speed")
@export var main_background: Sprite2D
@export var main_background_speed: float = 2.0

func setup():
	EventBus.background_move_requested.connect(move_main_background)


func move_main_background(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		main_background.position += direction * main_background_speed
