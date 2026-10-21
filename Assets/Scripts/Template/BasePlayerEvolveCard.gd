@abstract
extends TextureButton
class_name BasePlayerEvolveCardUI

## Each card script emits its own EventBus evolve signal before this one.
signal player_pick_card

@export_group("Cards Name")
@export var card_name_array: Array[String]
@export var card_name_text: RichTextLabel

var simple_tween: Tween


func _ready() -> void:
	pivot_offset_ratio = Vector2(0.5, 0.5)


## Shows the name of the level this card evolves the stat to (names go from level 1 up).
func show_level(level: int) -> void:
	var index: int = clampi(level - 1, 0, card_name_array.size() - 1)
	card_name_text.text = card_name_array[index]


## Connected in the card scenes to mouse_entered.
func on_card_mouse_entered() -> void:
	_tween_scale(Vector2(1.1, 1.1))


## Connected in the card scenes to mouse_exited.
func on_card_mouse_exited() -> void:
	_tween_scale(Vector2(1.0, 1.0))


## Connected in the card scenes to pressed.
func pick_card() -> void:
	player_pick_card.emit()


func _tween_scale(target_scale: Vector2) -> void:
	if simple_tween:
		simple_tween.kill()

	simple_tween = create_tween()
	simple_tween.set_trans(Tween.TRANS_QUAD)
	simple_tween.set_ease(Tween.EASE_OUT)
	simple_tween.tween_property(self, "scale", target_scale, 0.2)
