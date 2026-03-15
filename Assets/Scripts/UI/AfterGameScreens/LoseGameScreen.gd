extends Control
class_name LoseGameScreen

@export var main_scene : PackedScene
@export var main_menu : PackedScene

func _on_restart_game_button_pressed() -> void:
	var scene = main_scene.instantiate()
	get_tree().root.add_child(scene)
	self.queue_free()


func _on_main_menu_button_pressed() -> void:
	var scene = main_menu.instantiate()
	get_tree().root.add_child(scene)
	self.queue_free()
