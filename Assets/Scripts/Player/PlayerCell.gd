extends BaseCell
class_name PlayerCell

@export var player_economy_component : PlayerEconomyComponent
@export var player_evolve_component : PlayerEvolveComponent
@export var player_camera : Camera2D

var camera_scale_per_level : Vector2 = Vector2(0.2, 0.2)
var camera_tween : Tween

func _enter_tree() -> void:
	GlobalContext.player_instance = self
	
	
func player_cell_add_one_strength():
	set_cell_strength(cell_strength_value + 1)
	set_cell_size_scale()
	

func player_cell_add_one_immune():
	set_cell_immune(cell_immune_value + 1)
	set_cell_size_scale()
	

func player_cell_add_one_swiftness():
	set_cell_swiftness(cell_swiftness_value + 1)
	set_cell_size_scale()
	

func ping_ui_update_stats():
	GlobalContext.main_ui_instance.update_player_stats(cell_strength_value, cell_immune_value, cell_swiftness_value)
	
	var new_player_camera_zoom = player_camera.zoom - camera_scale_per_level
	
	if camera_tween:
		camera_tween.kill()
		
	camera_tween = create_tween()
	camera_tween.set_ease(Tween.EASE_IN_OUT)
	camera_tween.set_trans(Tween.TRANS_LINEAR)
	camera_tween.tween_property(player_camera, "zoom", new_player_camera_zoom, 0.25)
	
	
func _exit_tree() -> void:
	GlobalContext.player_instance = null
