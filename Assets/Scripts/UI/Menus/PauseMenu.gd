extends Control
class_name PauseMenu

@export var main_menu : PackedScene

func _on_contine_game_button_pressed() -> void:
	pass # Replace with function body.


func _on_main_menu_button_pressed() -> void:
	var scene = main_menu.instantiate()
	get_tree().root.add_child(scene)
	self.queue_free()
