extends Node
class_name EnemyManager

@export_group("Not Simple Enemy List")
@export var cells_to_destroy : Array[EnemyCell]

@export_group("Simple Enemy Spawner")
@export var simple_enemy_scene : PackedScene
@export var simple_enemy_spawn_timer : Timer
@export var simple_enemy_spawn_initial_count : int = 5
@export var simple_enemy_spawn_min_value : float = 1.5
@export var simple_enemy_spawn_max_value : float = 5
@export var simple_enemy_area_to_spawn : CollisionShape2D

@export_group("Enemy Spawner")
@export var enemy_scene : PackedScene
@export var enemy_spawn_timer : Timer
@export var enemy_spawn_initial_count : int = 5
@export var enemy_spawn_min_value : float = 1.5
@export var enemy_spawn_max_value : float = 5
@export var enemy_area_to_spawn : CollisionShape2D

func _ready() -> void:
	for i in range(simple_enemy_spawn_initial_count):
		spawn_simple_enemy()
	
	for i in range(enemy_spawn_initial_count):
		spawn_enemy()
	
	simple_enemy_spawn_timer.wait_time = randf_range(simple_enemy_spawn_min_value, simple_enemy_spawn_max_value)
	enemy_spawn_timer.wait_time = randf_range(enemy_spawn_min_value, enemy_spawn_max_value)
	

func check_win_condition():
	if cells_to_destroy.size() != 0:
		return
	else:
		GlobalContext.main_ui_instance.show_win_game_screen()


func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	enemy.global_position = get_random_point_in_area()
	
	var enemy_health_component = enemy.cell_health_component as EnemyCellHealthComponent
	enemy_health_component.cell_died.connect(check_win_condition)
	
	enemy_spawn_timer.wait_time = randf_range(
		enemy_spawn_min_value, 
		enemy_spawn_max_value
	)
	
	self.add_child(enemy)


func spawn_simple_enemy() -> void:
	var simple_enemy = simple_enemy_scene.instantiate()
	simple_enemy.global_position = get_random_point_in_area()
	
	simple_enemy_spawn_timer.wait_time = randf_range(
		simple_enemy_spawn_min_value, 
		simple_enemy_spawn_max_value
	)
	
	self.add_child(simple_enemy)


func get_random_point_in_area() -> Vector2:
	var shape = simple_enemy_area_to_spawn.shape
	
	if shape is RectangleShape2D:
		var extents = shape.size / 2 - Vector2(50, 50)
		var local_point = Vector2(
			randf_range(-extents.x, extents.x),
			randf_range(-extents.y, extents.y)
		)
		return simple_enemy_area_to_spawn.global_position + local_point
	return Vector2.ZERO
