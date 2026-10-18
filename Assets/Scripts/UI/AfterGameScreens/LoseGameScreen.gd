extends Control
class_name LoseGameScreen

@export var tutorial_scene: PackedScene
@export var main_menu: PackedScene


## Connected in LoseGameScreen.tscn to RestartGameButton.pressed.
func _on_restart_game_button_pressed() -> void:
	get_tree().change_scene_to_packed(tutorial_scene)


## Connected in LoseGameScreen.tscn to MainMenuButton.pressed.
func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu)
