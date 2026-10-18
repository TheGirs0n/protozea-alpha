extends Control
class_name MainMenuUI

# Loaded at runtime: an exported PackedScene here would close the
# MainMenu -> Tutorial -> MainScene -> result screen -> MainMenu cycle.
const TUTORIAL_SCENE_PATH: String = "res://Assets/Scenes/UI/Menus/TutorialMenu.tscn"


## Connected in MainMenu.tscn to StartGameButton.pressed.
func _on_start_game_button_pressed() -> void:
	var scene: Node = (load(TUTORIAL_SCENE_PATH) as PackedScene).instantiate()
	get_tree().root.add_child(scene)
	queue_free()
