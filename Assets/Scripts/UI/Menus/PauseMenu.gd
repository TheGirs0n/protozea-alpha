extends Control
class_name PauseMenu

@export var main_menu : PackedScene

func _on_contine_game_button_pressed() -> void:
	GlobalContext.main_scene_instance.continue_game()


func _on_main_menu_button_pressed() -> void:
	var scene = main_menu.instantiate()
	get_tree().root.add_child(scene)
	GlobalContext.main_scene_instance.queue_free()
