extends Control
class_name PauseMenu

@export var main_menu : PackedScene


func _on_continue_game_button_pressed() -> void:
	EventBus.continue_requested.emit()


func _on_main_menu_button_pressed() -> void:
	var scene := main_menu.instantiate()
	get_tree().root.add_child(scene)
	EventBus.go_to_main_menu_requested.emit()
