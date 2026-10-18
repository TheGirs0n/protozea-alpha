extends Control
class_name LoseGameScreen

@export var tutorial_scene: PackedScene
@export var main_menu: PackedScene


## Connected in LoseGameScreen.tscn to RestartGameButton.pressed.
func _on_restart_game_button_pressed() -> void:
	var scene: Node = tutorial_scene.instantiate()
	get_tree().root.add_child(scene)
	queue_free()


## Connected in LoseGameScreen.tscn to MainMenuButton.pressed.
func _on_main_menu_button_pressed() -> void:
	var scene: Node = main_menu.instantiate()
	get_tree().root.add_child(scene)
	queue_free()
