extends Control
class_name TutorialMenu

# A path for the same reason as in MainMenu: avoids a cyclic scene reference.
const MAIN_SCENE_PATH: String = "res://Assets/Scenes/Main/MainScene.tscn"


## Connected in TutorialMenu.tscn to Button.pressed.
func on_start_game_button() -> void:
	get_tree().change_scene_to_file(MAIN_SCENE_PATH)
