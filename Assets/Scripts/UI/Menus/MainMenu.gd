extends Control
class_name MainMenuUI

# A path, not an exported PackedScene: that would close the
# MainMenu -> Tutorial -> MainScene -> result screen -> MainMenu cycle.
const TUTORIAL_SCENE_PATH: String = "res://Assets/Scenes/UI/Menus/TutorialMenu.tscn"


## Connected in MainMenu.tscn to StartGameButton.pressed.
func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file(TUTORIAL_SCENE_PATH)
