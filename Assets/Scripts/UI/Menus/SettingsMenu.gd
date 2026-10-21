extends MarginContainer
class_name SettingsMenu

@export_group("Sound Sliders")
@export var master_slider: HSlider
@export var music_slider: HSlider
@export var sfx_slider: HSlider

@export_group("Language Buttons")
@export var en_button: Button
@export var ru_button: Button


func _ready() -> void:
	GameSettings.load_and_apply()
	master_slider.set_value_no_signal(GameSettings.get_bus_volume("Master"))
	music_slider.set_value_no_signal(GameSettings.get_bus_volume("Music"))
	sfx_slider.set_value_no_signal(GameSettings.get_bus_volume("SFX"))


## Connected in SettingsMenu.tscn to MasterProgressBar.value_changed.
func _on_master_progress_bar_value_changed(value: float) -> void:
	GameSettings.set_bus_volume("Master", value)


## Connected in SettingsMenu.tscn to MusicProgressBar.value_changed.
func _on_music_progress_bar_value_changed(value: float) -> void:
	GameSettings.set_bus_volume("Music", value)


## Connected in SettingsMenu.tscn to SFXProgressBar.value_changed.
func _on_sfx_progress_bar_value_changed(value: float) -> void:
	GameSettings.set_bus_volume("SFX", value)


## Connected in SettingsMenu.tscn to RULanguageButton.pressed.
func _on_ru_language_button_pressed() -> void:
	GameSettings.set_locale("ru")


## Connected in SettingsMenu.tscn to ENLanguageButton.pressed.
func _on_en_language_button_pressed() -> void:
	GameSettings.set_locale("en")
