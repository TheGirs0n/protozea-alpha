@abstract
extends TextureRect
class_name BasePlayerEvolveCardUI

enum PLAYER_STAT{
	STRENGTH,
	IMMUNE,
	SWIFTNESS
}

@export var player_evolve_stat : PLAYER_STAT
var simple_tween : Tween


func player_pick_card(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			pick_card()


func on_card_mouse_entered():
	if simple_tween:
		simple_tween.kill()
		
	simple_tween = create_tween()
	simple_tween.set_trans(Tween.TRANS_QUAD)
	simple_tween.set_ease(Tween.EASE_OUT)
	simple_tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2)


func on_card_mouse_exited():  
	if simple_tween:
		simple_tween.kill()
		
	simple_tween = create_tween()
	simple_tween.set_trans(Tween.TRANS_QUAD)
	simple_tween.set_ease(Tween.EASE_OUT)
	simple_tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)


func pick_card():
	pass
