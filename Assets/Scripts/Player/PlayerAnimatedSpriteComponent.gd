extends BaseCellAnimatedSprite
class_name PlayerCellAnimatedSpriteComponent

@export var sprites_array : Array[CompressedTexture2D]

func _ready() -> void:
	self.texture = sprites_array[0]


func _on_player_cell_stats_check_evolve(stat_sum: int) -> void:
	if stat_sum - 3 == 5:
		self.texture = sprites_array[1]
	elif stat_sum - 3 == 10:
		self.texture = sprites_array[2] 
	elif stat_sum - 3 == 15:
		self.texture = sprites_array[3]
