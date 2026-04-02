extends CanvasLayer
class_name TutorialMenu

@export var main_menu : PackedScene

func on_start_game_button() -> void:
	#var scene = ResourceLoader.load("res://Assets/Scenes/Main/MainScene.tscn").instantiate()
	var scene = main_menu.instantiate()
	get_tree().root.add_child(scene)
	self.queue_free()
