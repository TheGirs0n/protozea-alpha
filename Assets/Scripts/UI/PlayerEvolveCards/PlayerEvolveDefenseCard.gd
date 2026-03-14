extends PlayerEvolveCardUI
class_name PlayerEvolveDefenseCardUI

func pick_card():
	GlobalContext.player_instance.player_cell_add_one_immune()

var simple_tween : Tween

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
