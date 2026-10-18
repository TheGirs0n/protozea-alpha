extends Control
class_name TutorialMenu

# Loaded at runtime for the same reason as in MainMenu: avoids a cyclic scene reference.
const MAIN_SCENE_PATH: String = "res://Assets/Scenes/Main/MainScene.tscn"


## Connected in TutorialMenu.tscn to Button.pressed.
func on_start_game_button() -> void:
	var scene: Node = (load(MAIN_SCENE_PATH) as PackedScene).instantiate()
	get_tree().root.add_child(scene)
	queue_free()
