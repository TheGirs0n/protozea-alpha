extends CanvasLayer
class_name MainMenuUI

@export var tutorial_screen : PackedScene

func _on_start_game_button_pressed() -> void:
	var scene = tutorial_screen.instantiate()
	queue_free()
	get_tree().root.add_child(scene)
