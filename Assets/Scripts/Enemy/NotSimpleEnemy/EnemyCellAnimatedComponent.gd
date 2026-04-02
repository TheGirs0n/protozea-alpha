extends BaseCellAnimatedSprite
class_name EnemyCellAnimatedComponent

@export var sprites_array : Array[CompressedTexture2D]

func _ready() -> void:
	self.texture = sprites_array.pick_random()
