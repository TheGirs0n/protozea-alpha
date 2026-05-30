extends Control
class_name MainMenuUI

func _on_start_game_button_pressed() -> void:
	var scene = ResourceLoader.load("res://Assets/Scenes/UI/Menus/TutorialMenu.tscn").instantiate()
	get_tree().root.add_child(scene)
	queue_free()
