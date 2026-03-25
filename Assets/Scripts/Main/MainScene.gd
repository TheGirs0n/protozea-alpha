extends Node
class_name MainScene

@export var main_level : MainLevel

func _ready() -> void:
	GlobalContext.main_scene_instance = self
	GlobalContext.player_instance.player_evolve_component.player_click_evolve.connect(pause_player)
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game"):
		pause_game()
		
	
func pause_player():
	GlobalContext.player_instance.process_mode = Node.PROCESS_MODE_DISABLED


func pause_game():
	main_level.process_mode = Node.PROCESS_MODE_DISABLED
	GlobalContext.main_ui_instance.show_pause()


func continue_game():
	main_level.process_mode = Node.PROCESS_MODE_INHERIT
	GlobalContext.main_ui_instance.hide_pause()
	
func continue_player():
	GlobalContext.player_instance.process_mode = Node.PROCESS_MODE_INHERIT

	
func _exit_tree() -> void:
	GlobalContext.main_scene_instance = null
