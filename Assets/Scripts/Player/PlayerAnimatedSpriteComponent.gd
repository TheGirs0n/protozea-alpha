extends BaseCellAnimatedSprite
class_name PlayerCellAnimatedSpriteComponent

@export var sprites_array: Array[CompressedTexture2D]


func _ready() -> void:
	super()
	texture = sprites_array[0]


## Connected in Player.tscn to PlayerCell.player_cell_stats_check_evolve.
func _on_player_cell_stats_check_evolve(stat_sum: int) -> void:
	if stat_sum - 3 == 5:
		texture = sprites_array[1]
	elif stat_sum - 3 == 10:
		texture = sprites_array[2]
	elif stat_sum - 3 == 15:
		texture = sprites_array[3]
