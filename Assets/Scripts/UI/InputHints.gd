extends RefCounted
class_name InputHints

## Key names for on-screen hints, read from the Input Map instead of written by hand.


## Name of the first keyboard key bound to the action, or the action name if none.
static func first_key(action: StringName) -> String:
	for event: InputEvent in InputMap.action_get_events(action):
		var key: InputEventKey = event as InputEventKey
		if key != null:
			return key.as_text_physical_keycode()
	return String(action)
