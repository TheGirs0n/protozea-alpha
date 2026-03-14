extends Node
class_name MainScene


func _ready() -> void:
	GlobalContext.main_scene_instance = self
	GlobalContext.player_instance.player_evolve_component.player_click_evolve.connect(pause_game)
	
	
func pause_game():
	GlobalContext.player_instance.process_mode = Node.PROCESS_MODE_DISABLED


func continue_game():
	GlobalContext.player_instance.process_mode = Node.PROCESS_MODE_INHERIT

	
func _exit_tree() -> void:
	GlobalContext.main_scene_instance = null
