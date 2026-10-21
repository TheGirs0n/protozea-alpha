extends Control
class_name PauseMenu

@export var main_menu: PackedScene


## Connected in PauseMenu.tscn to ContinueGameButton.pressed.
func _on_continue_game_button_pressed() -> void:
	EventBus.continue_requested.emit()


## Connected in PauseMenu.tscn to MainMenuButton.pressed.
func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu)
