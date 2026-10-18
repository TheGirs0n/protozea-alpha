extends Control
class_name WinGameScreen

@export var main_menu: PackedScene


## Connected in WinGameScreen.tscn to MainMenuButton.pressed.
func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu)
