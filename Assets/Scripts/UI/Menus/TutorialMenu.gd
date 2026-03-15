extends CanvasLayer
class_name TutorialMenu

@export var game_scene : PackedScene


func on_start_game_button() -> void:
	var scene = game_scene.instantiate()
	get_tree().root.add_child(scene)
	self.queue_free()
