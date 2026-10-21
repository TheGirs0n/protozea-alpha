extends Control
class_name TutorialMenu

# A path for the same reason as in MainMenu: avoids a cyclic scene reference.
const MAIN_SCENE_PATH: String = "res://Assets/Scenes/Main/MainScene.tscn"

@export var controls_text: RichTextLabel


func _ready() -> void:
	_update_controls_text()


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED and is_node_ready():
		_update_controls_text()


## Connected in TutorialMenu.tscn to Button.pressed.
func on_start_game_button() -> void:
	get_tree().change_scene_to_file(MAIN_SCENE_PATH)


## Keys come from the Input Map, so the text follows any rebinding.
func _update_controls_text() -> void:
	var move_keys: String = (
		InputHints.first_key(&"move_up")
		+ InputHints.first_key(&"move_left")
		+ InputHints.first_key(&"move_down")
		+ InputHints.first_key(&"move_right")
	)
	controls_text.text = tr("CONTROLS_TEXT") % [
		move_keys, InputHints.first_key(&"try_evolve"), InputHints.first_key(&"pause_game")
	]
