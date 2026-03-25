extends CanvasLayer
class_name MainMenuUI

@export var tutorial_screen : PackedScene

func _on_start_game_button_pressed() -> void:
	var scene = tutorial_screen.instantiate()
	queue_free()
	get_tree().root.add_child(scene)

func _on_master_progress_bar_value_changed(value: float) -> void:
	pass # Replace with function body.
	AudioServer.set_bus_volume_linear(0, value)

func _on_music_progress_bar_value_changed(value: float) -> void:
	pass # Replace with function body.
	AudioServer.set_bus_volume_linear(1, value)


func _on_sfx_progress_bar_value_changed(value: float) -> void:
	pass # Replace with function body.
	AudioServer.set_bus_volume_linear(2, value)


func _on_ru_language_button_pressed() -> void:
	pass # Replace with function body.
	TranslationServer.set_locale("RU")

func _on_en_language_button_pressed() -> void:
	pass # Replace with function body.
	TranslationServer.set_locale("EN")
