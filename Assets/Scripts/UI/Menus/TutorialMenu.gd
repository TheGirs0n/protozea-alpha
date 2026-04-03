extends Control
class_name TutorialMenu

func on_start_game_button() -> void:
	var scene = ResourceLoader.load("res://Assets/Scenes/Main/MainScene.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.queue_free()
