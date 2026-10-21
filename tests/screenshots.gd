extends SceneTree
## Saves screenshots of the main screens for a visual check. Needs a real renderer:
##   SHOTS_DIR=/tmp/shots xvfb-run -a -s "-screen 0 1280x720x24" \
##     godot --path . --rendering-driver opengl3 --fixed-fps 60 -s res://tests/screenshots.gd
## Without SHOTS_DIR the images go to user://screenshots.

@warning_ignore_start(
	"unsafe_method_access", "unsafe_property_access", "unsafe_call_argument", "unsafe_cast"
)

var _out: String = ""


func _initialize() -> void:
	_out = OS.get_environment("SHOTS_DIR")
	if _out.is_empty():
		_out = ProjectSettings.globalize_path("user://screenshots")
	DirAccess.make_dir_recursive_absolute(_out)
	_run.call_deferred()


func _frames(count: int) -> void:
	for i: int in count:
		await process_frame


func _shot(name: String) -> void:
	await _frames(2)
	var image: Image = root.get_texture().get_image()
	image.save_png(_out.path_join(name + ".png"))
	print("saved ", _out.path_join(name + ".png"))


func _press(node: Node, action: StringName) -> void:
	var event: InputEventAction = InputEventAction.new()
	event.action = action
	event.pressed = true
	node.call(&"_input", event)


func _run() -> void:
	change_scene_to_file("res://Assets/Scenes/UI/Menus/MainMenu.tscn")
	await _frames(5)
	await _shot("01_main_menu")
	change_scene_to_file("res://Assets/Scenes/UI/Menus/TutorialMenu.tscn")
	await _frames(5)
	await _shot("02_tutorial")

	change_scene_to_file("res://Assets/Scenes/Main/MainScene.tscn")
	await _frames(10)
	var main: Node = current_scene
	var player: Node2D = main.get_node("MainLevel/Player")
	var bus: Node = root.get_node("EventBus")
	bus.emit_signal(&"money_earned", 7)
	await _frames(30)
	await _shot("03_hud")
	_press(player.get(&"player_evolve_component"), &"try_evolve")
	await _frames(10)
	await _shot("04_evolve_cards")
	var cards: Node = main.get_node("MainUi").find_child("PlayerEvolveCardsUi", true, false)
	cards.get(&"player_damage_evolve_card").emit_signal(&"pressed")
	await _frames(5)

	var enemy: Node2D = (main.get_node("MainLevel/EnemyManager").get(&"predators") as Array)[0]
	enemy.get(&"cell_health_component").set(&"cell_current_health", 50.0)
	player.get(&"cell_health_component").set(&"cell_current_defense", 1000)
	bus.emit_signal(&"battle_requested", player, enemy)
	await _frames(90)
	await _shot("05_battle")
	_press(main, &"pause_game")
	await _frames(5)
	await _shot("06_pause")
	_press(main, &"pause_game")
	await _frames(2)

	change_scene_to_file("res://Assets/Scenes/UI/AfterGameScreens/LoseGameScreen.tscn")
	await _frames(60)
	await _shot("07_lose")
	change_scene_to_file("res://Assets/Scenes/UI/AfterGameScreens/WinGameScreen.tscn")
	await _frames(60)
	await _shot("08_win")
	quit()
