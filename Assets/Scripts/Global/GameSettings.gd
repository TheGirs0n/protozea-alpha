extends RefCounted
class_name GameSettings

## Player settings (volume per audio bus, language) stored in user://settings.cfg.

const PATH: String = "user://settings.cfg"
const AUDIO_SECTION: String = "audio"
const LOCALE_SECTION: String = "locale"
const LOCALE_KEY: String = "locale"
const BUSES: PackedStringArray = ["Master", "Music", "SFX"]


## Applies the saved settings. The settings menu calls it when it opens,
## and the main menu contains one, so this runs at startup.
static func load_and_apply() -> void:
	var config: ConfigFile = ConfigFile.new()
	if config.load(PATH) != OK:
		return
	for bus: String in BUSES:
		var index: int = AudioServer.get_bus_index(bus)
		if index != -1 and config.has_section_key(AUDIO_SECTION, bus):
			var volume: float = config.get_value(AUDIO_SECTION, bus, 1.0)
			AudioServer.set_bus_volume_linear(index, volume)
	if config.has_section_key(LOCALE_SECTION, LOCALE_KEY):
		var locale: String = config.get_value(LOCALE_SECTION, LOCALE_KEY, "")
		TranslationServer.set_locale(locale)


static func get_bus_volume(bus: String) -> float:
	return AudioServer.get_bus_volume_linear(AudioServer.get_bus_index(bus))


static func set_bus_volume(bus: String, value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index(bus), value)
	_save_value(AUDIO_SECTION, bus, value)


static func set_locale(locale: String) -> void:
	TranslationServer.set_locale(locale)
	_save_value(LOCALE_SECTION, LOCALE_KEY, locale)


static func _save_value(section: String, key: String, value: Variant) -> void:
	var config: ConfigFile = ConfigFile.new()
	var load_error: Error = config.load(PATH)
	if load_error != OK and load_error != ERR_FILE_NOT_FOUND:
		push_warning("Settings file is unreadable and will be rewritten: %s" % error_string(load_error))
	config.set_value(section, key, value)
	var save_error: Error = config.save(PATH)
	if save_error != OK:
		push_warning("Could not save settings: %s" % error_string(save_error))
