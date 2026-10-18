extends Control
class_name WinGameScreen

@export var main_menu: PackedScene


## Connected in WinGameScreen.tscn to MainMenuButton.pressed.
func _on_main_menu_button_pressed() -> void:
	var scene: Node = main_menu.instantiate()
	get_tree().root.add_child(scene)
	queue_free()
