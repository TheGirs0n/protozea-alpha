extends BaseCellAnimatedSprite
class_name PlayerCellAnimatedSpriteComponent

@export var sprites_array: Array[CompressedTexture2D]
## Stat sum from which sprites_array[i + 1] is shown (start stats 1/1/1 sum to 3).
@export var sprite_stat_sum_thresholds: Array[int] = [8, 13, 18]


func _ready() -> void:
	super()
	texture = sprites_array[0]


## Connected in Player.tscn to PlayerCell.player_cell_stats_check_evolve.
func _on_player_cell_stats_check_evolve(stat_sum: int) -> void:
	var sprite_index: int = 0
	for threshold: int in sprite_stat_sum_thresholds:
		if stat_sum >= threshold:
			sprite_index += 1
	texture = sprites_array[mini(sprite_index, sprites_array.size() - 1)]
