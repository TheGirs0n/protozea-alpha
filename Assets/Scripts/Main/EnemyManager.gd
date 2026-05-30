extends Node
class_name EnemyManager

@export_group("Not Simple Enemy List")
@export var cells_to_destroy: Array[EnemyCell]
@export var simple_cell_array: Array[SimpleEnemyCell]

@export_group("Simple Enemy Spawner")
@export var simple_enemy_scene: PackedScene
@export var simple_enemy_spawn_timer: Timer
@export var simple_enemy_spawn_initial_count: int = 5
@export var simple_enemy_spawn_max_count: int = 10
@export var simple_enemy_spawn_min_value: float = 3
@export var simple_enemy_spawn_max_value: float = 10
@export var simple_enemy_area_to_spawn: CollisionShape2D

@export_group("Enemy Spawner")
@export var enemy_scene: PackedScene
@export var enemy_spawn_timer: Timer
@export var enemy_spawn_initial_count: int = 5
@export var enemy_spawn_max_count: int = 10
@export var enemy_spawn_min_value: float = 1.5
@export var enemy_spawn_max_value: float = 5
@export var enemy_area_to_spawn: CollisionShape2D


func setup(_player: BaseCell) -> void:
	# Зарезервировано для будущей логики, зависящей от игрока
	pass


func _ready() -> void:
	for i in range(simple_enemy_spawn_initial_count):
		spawn_simple_enemy()

	for i in range(enemy_spawn_initial_count):
		spawn_enemy()

	simple_enemy_spawn_timer.wait_time = randf_range(
		simple_enemy_spawn_min_value, simple_enemy_spawn_max_value
	)
	enemy_spawn_timer.wait_time = randf_range(
		enemy_spawn_min_value, enemy_spawn_max_value
	)


func _check_win_condition() -> void:
	# FIX: was checking size() != 0 — inverted condition, win was impossible
	if cells_to_destroy.is_empty():
		EventBus.all_enemies_cleared.emit()


func spawn_enemy() -> void:
	if cells_to_destroy.size() >= enemy_spawn_max_count:
		return

	var enemy := enemy_scene.instantiate() as EnemyCell
	enemy.cell_start_stats_resource = CellStatsResourceFabric.create_random()
	enemy.global_position = get_random_point_in_area(enemy_area_to_spawn)

	var health_comp := enemy.cell_health_component as EnemyCellHealthComponent

	# FIX: при смерти удаляем из массива и эмитим событие
	health_comp.cell_died.connect(func() -> void:
		cells_to_destroy.erase(enemy)
		EventBus.enemy_died.emit(enemy)
		_check_win_condition()
	)

	enemy_spawn_timer.wait_time = randf_range(
		enemy_spawn_min_value, enemy_spawn_max_value
	)

	cells_to_destroy.append(enemy)
	add_child(enemy)


func spawn_simple_enemy() -> void:
	if simple_cell_array.size() >= simple_enemy_spawn_max_count:
		return

	var simple_enemy := simple_enemy_scene.instantiate() as SimpleEnemyCell
	simple_enemy.global_position = get_random_point_in_area(simple_enemy_area_to_spawn)

	simple_enemy_spawn_timer.wait_time = randf_range(
		simple_enemy_spawn_min_value, simple_enemy_spawn_max_value
	)

	# FIX: убираем из массива когда узел удаляется из дерева
	simple_enemy.tree_exited.connect(func() -> void:
		simple_cell_array.erase(simple_enemy)
	)

	simple_cell_array.append(simple_enemy)
	add_child(simple_enemy)


func get_random_point_in_area(area: CollisionShape2D) -> Vector2:
	# FIX: раньше всегда использовался simple_enemy_area_to_spawn
	var shape := area.shape

	if shape is RectangleShape2D:
		var extents : Vector2 = shape.size / 2 - Vector2(50, 50)
		var local_point := Vector2(
			randf_range(-extents.x, extents.x),
			randf_range(-extents.y, extents.y)
		)
		return area.global_position + local_point

	return Vector2.ZERO


func _on_simple_enemy_spawn_timer_timeout() -> void:
	spawn_simple_enemy()


func _on_enemy_spawn_timer_timeout() -> void:
	spawn_enemy()
