extends Node
class_name EnemyManager

const SPAWN_ATTEMPTS: int = 10

@export_group("Win Condition")
## How many predators the player has to eat to win.
@export var predators_to_win: int = 15

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
## Predators roll every stat up to the player's average stat plus this bonus.
@export var predator_stat_bonus: int = 0
## Predators never appear closer than this to the player.
@export var safe_spawn_radius: float = 200.0

var predators: Array[EnemyCell] = []
var plankton: Array[SimpleEnemyCell] = []
var eaten_count: int = 0

var _player: BaseCell = null


## Spawns the starting cells once the player is known (spawning depends on it).
func setup(player: BaseCell) -> void:
	_player = player

	for i: int in range(simple_enemy_spawn_initial_count):
		spawn_simple_enemy()

	for i: int in range(enemy_spawn_initial_count):
		spawn_enemy()

	simple_enemy_spawn_timer.wait_time = randf_range(
		simple_enemy_spawn_min_value, simple_enemy_spawn_max_value
	)
	enemy_spawn_timer.wait_time = randf_range(
		enemy_spawn_min_value, enemy_spawn_max_value
	)


## Connected in MainLevel.tscn to EnemyManager/Timer2.timeout.
func spawn_enemy() -> void:
	if predators.size() >= enemy_spawn_max_count:
		return

	var enemy: EnemyCell = enemy_scene.instantiate() as EnemyCell
	enemy.cell_start_stats_resource = CellStartStatResource.create_random(
		enemy.cell_balance, _get_predator_stat_cap(enemy.cell_balance)
	)
	enemy.global_position = _get_spawn_point(enemy_area_to_spawn, safe_spawn_radius)
	enemy.cell_health_component.cell_died.connect(_on_predator_eaten.bind(enemy))

	enemy_spawn_timer.wait_time = randf_range(
		enemy_spawn_min_value, enemy_spawn_max_value
	)

	predators.append(enemy)
	add_child(enemy)


## Connected in MainLevel.tscn to EnemyManager/Timer.timeout.
func spawn_simple_enemy() -> void:
	if plankton.size() >= simple_enemy_spawn_max_count:
		return

	var simple_enemy: SimpleEnemyCell = simple_enemy_scene.instantiate() as SimpleEnemyCell
	simple_enemy.global_position = get_random_point_in_area(simple_enemy_area_to_spawn)

	simple_enemy_spawn_timer.wait_time = randf_range(
		simple_enemy_spawn_min_value, simple_enemy_spawn_max_value
	)

	# Убираем из массива, когда узел удаляется из дерева
	simple_enemy.tree_exited.connect(func() -> void:
		plankton.erase(simple_enemy)
	)

	plankton.append(simple_enemy)
	add_child(simple_enemy)


func get_random_point_in_area(area: CollisionShape2D) -> Vector2:
	var rectangle: RectangleShape2D = area.shape as RectangleShape2D
	if rectangle == null:
		return Vector2.ZERO

	var extents: Vector2 = rectangle.size / 2 - Vector2(50, 50)
	var local_point: Vector2 = Vector2(
		randf_range(-extents.x, extents.x),
		randf_range(-extents.y, extents.y)
	)
	return area.global_position + local_point


## Predators only die in battles with the player, so every death is a meal.
func _on_predator_eaten(enemy: EnemyCell) -> void:
	predators.erase(enemy)
	eaten_count += 1
	EventBus.predator_eaten.emit(eaten_count, predators_to_win)
	if eaten_count >= predators_to_win:
		EventBus.game_won.emit()


func _get_predator_stat_cap(balance: CellBalanceConfig) -> int:
	if _player == null:
		return balance.max_stat
	var stat_sum: int = (
		_player.cell_strength_value + _player.cell_immune_value + _player.cell_swiftness_value
	)
	var average: int = floori(stat_sum / 3.0)
	return clampi(average + predator_stat_bonus, balance.min_stat, balance.max_stat)


func _get_spawn_point(area: CollisionShape2D, keep_away: float) -> Vector2:
	var point: Vector2 = get_random_point_in_area(area)
	for i: int in SPAWN_ATTEMPTS:
		if _player == null or point.distance_to(_player.global_position) >= keep_away:
			break
		point = get_random_point_in_area(area)
	return point
