extends Node2D
class_name MainLevel

@export_group("Background Parallax")
@export var main_background: Sprite2D
## How much the background shifts with the player's offset from the start point (0 = static).
@export var main_background_parallax: float = 0.3

var _player: Node2D = null
var _background_origin: Vector2
var _player_origin: Vector2
var _min_offset: Vector2
var _max_offset: Vector2


func _process(_delta: float) -> void:
	if _player == null or not is_instance_valid(_player):
		return
	var offset: Vector2 = (_player.global_position - _player_origin) * main_background_parallax
	main_background.position = _background_origin + offset.clamp(_min_offset, _max_offset)


func setup(player: Node2D) -> void:
	_player = player
	_player_origin = player.global_position
	_background_origin = main_background.position
	# The background may shift only while its edges stay outside the visible area
	var half_size: Vector2 = main_background.texture.get_size() * main_background.scale / 2.0
	var view_size: Vector2 = get_viewport_rect().size
	_max_offset = (half_size - _background_origin).max(Vector2.ZERO)
	_min_offset = (view_size - _background_origin - half_size).min(Vector2.ZERO)
