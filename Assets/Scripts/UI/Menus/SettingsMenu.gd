extends MarginContainer
class_name SettingsMenu

@export_group("Sound Sliders")
@export var master_slider : HSlider
@export var music_slider : HSlider
@export var sfx_slider : HSlider

@export_group("Language Buttons")
@export var en_button : TextureButton
@export var ru_button : TextureButton


func _ready() -> void:
	master_slider.value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Master"))
	music_slider.value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Music"))
	sfx_slider.value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("SFX"))


func _on_master_progress_bar_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)


func _on_music_progress_bar_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), value)


func _on_sfx_progress_bar_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), value)


func _on_ru_language_button_pressed() -> void:
	TranslationServer.set_locale("RU")


func _on_en_language_button_pressed() -> void:
	TranslationServer.set_locale("EN")
