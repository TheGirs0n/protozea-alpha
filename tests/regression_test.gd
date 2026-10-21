extends SceneTree
## Gameplay regression tests. Run from the project root:
##   godot --headless --path . --fixed-fps 60 -s res://tests/regression_test.gd
## Prints PASS/FAIL per check and "RESULT: n failed"; the exit code is 1 when anything
## failed (0 = all green). Any "SCRIPT ERROR" in the output is a failure as well.
## Tests drive the real scenes through their public signals and methods; the
## settings test restores user://settings.cfg and the locale when it is done.

@warning_ignore_start(
	"unsafe_method_access", "unsafe_property_access", "unsafe_call_argument", "unsafe_cast"
)

const MAIN_SCENE_PATH: String = "res://Assets/Scenes/Main/MainScene.tscn"
const MAIN_MENU_PATH: String = "res://Assets/Scenes/UI/Menus/MainMenu.tscn"

var _failed: int = 0


func _initialize() -> void:
	_run.call_deferred()


func _check(name: String, ok: bool, details: String) -> void:
	if ok:
		print("PASS ", name, "  (", details, ")")
	else:
		_failed += 1
		print("FAIL ", name, "  (", details, ")")


func _frames(count: int) -> void:
	for i: int in count:
		await process_frame


func _spawn_main() -> Node:
	change_scene_to_file(MAIN_SCENE_PATH)
	await _frames(3)
	return current_scene


func _clear_scene() -> void:
	var scene: Node = current_scene
	if scene != null:
		scene.queue_free()
	await _frames(2)
	current_scene = null


func _press(node: Node, action: StringName) -> void:
	var event: InputEventAction = InputEventAction.new()
	event.action = action
	event.pressed = true
	node.call(&"_input", event)


func _visible_card(cards_ui: Node) -> Node:
	for child: Node in cards_ui.get_children():
		if child is Control and (child as Control).visible:
			return child
	return null


func _visible_card_names(cards_ui: Node) -> PackedStringArray:
	var names: PackedStringArray = []
	if cards_ui == null:
		return names
	for child: Node in cards_ui.get_children():
		if child is Control and (child as Control).visible:
			names.append(child.name)
	return names


func _run() -> void:
	_test_balance_parity()
	await _test_evolve()
	await _test_final_evolve()
	await _test_enemy_speed_after_chase()
	await _test_real_battle()
	await _test_lose()
	await _test_win()
	await _test_start_balance()
	await _test_sprite_scale_drift()
	await _test_background_parallax()
	await _test_overlap_after_battle()
	await _test_no_evolve_in_battle()
	await _test_pause_toggle()
	await _test_navigation()
	await _test_menus_and_settings()
	print("RESULT: ", _failed, " failed")
	quit(1 if _failed > 0 else 0)


func _test_balance_parity() -> void:
	var balance: Resource = load("res://Assets/Resources/CellResources/CellBalance.tres")
	var mismatches: PackedStringArray = []
	for s: int in range(1, 7):
		var old_damage: float = 1 + (s - 1) * 0.5
		var old_health: float = 5 + 2 * (s - 1)
		var old_defense: int = s * 5
		var old_speed: float = s * 60 - 50 * (s - 1)
		var old_gain: float = 3 - (0.3 - (s - 1))
		if not is_equal_approx(balance.damage(s), old_damage):
			mismatches.append("damage %d" % s)
		if not is_equal_approx(balance.health(s), old_health):
			mismatches.append("health %d" % s)
		if balance.defense(s) != old_defense:
			mismatches.append("defense %d" % s)
		if not is_equal_approx(balance.speed(s), old_speed):
			mismatches.append("speed %d" % s)
		if not is_equal_approx(balance.endurance_gain(s), old_gain):
			mismatches.append("gain %d" % s)
	var old_scale: Vector2 = Vector2(0.5, 0.5) + Vector2(0.05, 0.05) * (2 - 1 + 3 - 1 + 4 - 1)
	if not balance.cell_scale(2, 3, 4).is_equal_approx(old_scale):
		mismatches.append("scale")
	if balance.max_endurance != 10 or not is_equal_approx(balance.endurance_tick, 0.5):
		mismatches.append("endurance")
	if balance.min_stat != 1 or balance.max_stat != 5:
		mismatches.append("stat range")
	_check(
		"balance: defaults match the old hardcoded formulas",
		mismatches.is_empty(),
		"mismatches=%s" % [mismatches]
	)


func _test_evolve() -> void:
	var main: Node = await _spawn_main()
	var player: Node = main.get_node("MainLevel/Player")
	var evolve: Node = player.get(&"player_evolve_component")
	var economy: Node = player.get(&"player_economy_component")
	var hint: CanvasItem = main.get_node("MainUi").get(&"player_can_evolve_text")
	var costs: Array = evolve.get(&"cell_evolve_array_cost")
	var bus: Node = root.get_node("EventBus")

	_check("evolve: no hint without money", not hint.visible, "hint=%s" % hint.visible)
	# Enough for exactly the first two evolutions.
	var start_money: int = int(costs[0]) + int(costs[1])
	bus.emit_signal(&"money_earned", start_money)
	await _frames(1)
	_check(
		"evolve: allowed with enough money",
		evolve.get(&"can_player_evolve_in_current") == true,
		"money=%d cost=%d" % [economy.get(&"player_current_money"), costs[0]]
	)
	_check("evolve: hint shown", hint.visible, "hint=%s" % hint.visible)

	_press(evolve, &"try_evolve")
	await _frames(1)
	var cards_ui: Node = main.get_node("MainUi").find_child("PlayerEvolveCardsUi", true, false)
	_check("evolve: cards UI opened", cards_ui != null, "cards_ui=%s" % cards_ui)
	if cards_ui == null:
		await _clear_scene()
		return
	_check("evolve: hint hidden while choosing", not hint.visible, "hint=%s" % hint.visible)
	_check(
		"evolve: three stat cards offered",
		_visible_card_names(cards_ui).size() == 3,
		"cards=%s" % [_visible_card_names(cards_ui)]
	)
	var damage_card: Node = cards_ui.get(&"player_damage_evolve_card")
	var expected_name: String = (damage_card.get(&"card_name_array") as Array)[int(
		player.get(&"cell_strength_value")
	)]
	var shown_name: String = (damage_card.get(&"card_name_text") as RichTextLabel).text
	_check(
		"evolve: card name matches the next level",
		shown_name == expected_name,
		"shown=%s expected=%s" % [shown_name, expected_name]
	)
	_visible_card(cards_ui).emit_signal(&"pressed")
	await _frames(2)

	var money_after: int = economy.get(&"player_current_money")
	var index_after: int = evolve.get(&"cell_current_evolve_index")
	_check(
		"evolve: one evolution charges one cost",
		money_after == start_money - int(costs[0]),
		"money %d -> %d, expected %d" % [start_money, money_after, start_money - int(costs[0])]
	)
	_check("evolve: index advances by one", index_after == 1, "index=%d" % index_after)
	_check(
		"evolve: leftover money re-enables next evolution immediately",
		evolve.get(&"can_player_evolve_in_current") == true,
		(
			"flag=%s money=%d next_cost=%d"
			% [evolve.get(&"can_player_evolve_in_current"), money_after, costs[index_after]]
		)
	)
	_check("evolve: hint back after the pick", hint.visible, "hint=%s" % hint.visible)
	_check(
		"evolve: player resumed",
		player.process_mode == Node.PROCESS_MODE_INHERIT,
		"process_mode=%d" % player.process_mode
	)
	await _clear_scene()


func _test_final_evolve() -> void:
	var main: Node = await _spawn_main()
	var player: Node = main.get_node("MainLevel/Player")
	var evolve: Node = player.get(&"player_evolve_component")
	var hint: CanvasItem = main.get_node("MainUi").get(&"player_can_evolve_text")
	var bar: Node = main.get_node("MainUi").get(&"player_evolve_progress_bar")
	var bar_text: RichTextLabel = bar.get(&"player_evolve_progress_bar_text")
	var bus: Node = root.get_node("EventBus")
	var max_stat: int = player.get(&"cell_balance").get(&"max_stat")
	player.call(&"set_cell_strength", max_stat)
	player.call(&"set_cell_immune", max_stat)
	player.call(&"set_cell_swiftness", max_stat)

	bus.emit_signal(&"money_earned", 500)
	await _frames(1)
	_press(evolve, &"try_evolve")
	await _frames(1)
	var cards_ui: Node = main.get_node("MainUi").find_child("PlayerEvolveCardsUi", true, false)
	_check(
		"final: only the final card is offered",
		_visible_card_names(cards_ui) == PackedStringArray(["PlayerEvolveFinalCard"]),
		"cards=%s" % [_visible_card_names(cards_ui)]
	)
	if cards_ui == null:
		await _clear_scene()
		return
	await _frames(1)
	var final_card: Control = cards_ui.get(&"player_final_evolve_card")
	_check(
		"final: the final card has a clickable size",
		final_card.size.x > 50 and final_card.size.y > 50,
		"size=%s" % final_card.size
	)
	_visible_card(cards_ui).emit_signal(&"pressed")
	await _frames(2)
	_check(
		"final: stats go past the cap",
		int(player.get(&"cell_strength_value")) == max_stat + 1,
		"strength=%d" % player.get(&"cell_strength_value")
	)
	_check(
		"final: evolution finished",
		(
			evolve.get(&"is_final_evolve") == true
			and evolve.get(&"can_player_evolve_in_current") == false
		),
		(
			"final=%s can=%s"
			% [evolve.get(&"is_final_evolve"), evolve.get(&"can_player_evolve_in_current")]
		)
	)

	bus.emit_signal(&"money_earned", 500)
	await _frames(1)
	_press(evolve, &"try_evolve")
	await _frames(1)
	var again: Node = main.get_node("MainUi").find_child("PlayerEvolveCardsUi", true, false)
	_check("final: E no longer opens (empty) cards", again == null, "cards_ui=%s" % again)
	_check(
		"final: player not stuck",
		player.process_mode == Node.PROCESS_MODE_INHERIT,
		"process_mode=%d" % player.process_mode
	)
	_check("final: no hint after the end", not hint.visible, "hint=%s" % hint.visible)
	_check(
		"final: bar shows the finished text",
		bar_text.text == "PLAYER_EVOLVE_OVERALL_TEXT",
		"text=%s" % bar_text.text
	)
	await _clear_scene()


func _test_enemy_speed_after_chase() -> void:
	var main: Node = await _spawn_main()
	var manager: Node = main.get_node("MainLevel/EnemyManager")
	var enemy: Node = (manager.get(&"predators") as Array)[0]
	var movement: Node = enemy.get(&"cell_movement_component")
	var speed_before: float = movement.get(&"cell_current_speed")
	movement.call(&"change_state", true)
	movement.call(&"change_state", false)
	var speed_after: float = movement.get(&"cell_current_speed")
	_check(
		"enemy: wander speed survives a chase",
		is_equal_approx(speed_before, speed_after),
		(
			"swiftness=%d speed %.1f -> %.1f"
			% [enemy.get(&"cell_swiftness_value"), speed_before, speed_after]
		)
	)
	await _clear_scene()


func _test_real_battle() -> void:
	var main: Node = await _spawn_main()
	var player: Node2D = main.get_node("MainLevel/Player")
	var economy: Node = player.get(&"player_economy_component")
	var hint: CanvasItem = main.get_node("MainUi").get(&"player_can_evolve_text")
	var manager: Node = main.get_node("MainLevel/EnemyManager")
	var enemy: Node2D = (manager.get(&"predators") as Array)[0]
	var enemy_id: int = enemy.get_instance_id()
	var enemy_health: Node = enemy.get(&"cell_health_component")
	var player_health: Node = player.get(&"cell_health_component")
	# Player can't be hit, enemy dies on the first hit; enough money to evolve after the kill.
	player_health.set(&"cell_current_defense", 1000)
	enemy_health.set(&"cell_current_health", 0.1)
	root.get_node("EventBus").emit_signal(&"money_earned", 100)
	var money_before: int = economy.get(&"player_current_money")
	enemy.global_position = player.global_position + Vector2(5, 0)
	var started: bool = false
	var in_battle_seen: bool = false
	var hint_in_battle: bool = false
	for i: int in 600:
		await process_frame
		if not started and player.get(&"cell_auto_battle_component").get(&"target_cell") != null:
			started = true
			in_battle_seen = (
				player_health.get(&"in_battle") == true and enemy_health.get(&"in_battle") == true
			)
			hint_in_battle = hint.visible
		if instance_from_id(enemy_id) == null:
			break
	_check("battle: contact starts a battle", started, "started=%s" % started)
	_check("battle: both sides marked in_battle", in_battle_seen, "in_battle=%s" % in_battle_seen)
	_check("battle: hint hidden during the battle", not hint_in_battle, "hint=%s" % hint_in_battle)
	_check(
		"battle: dead enemy is freed",
		instance_from_id(enemy_id) == null,
		"alive=%s" % (instance_from_id(enemy_id) != null)
	)
	await _frames(2)
	_check(
		"battle: player leaves battle state",
		player_health.get(&"in_battle") == false,
		"in_battle=%s" % player_health.get(&"in_battle")
	)
	_check(
		"battle: player moves again",
		player.get(&"cell_movement_component").process_mode == Node.PROCESS_MODE_INHERIT,
		"mode=%d" % player.get(&"cell_movement_component").process_mode
	)
	_check(
		"battle: enemy pays money",
		int(economy.get(&"player_current_money")) > money_before,
		"money %d -> %d" % [money_before, economy.get(&"player_current_money")]
	)
	_check("battle: hint comes back after the battle", hint.visible, "hint=%s" % hint.visible)
	await _clear_scene()


func _test_lose() -> void:
	var main: Node = await _spawn_main()
	var main_id: int = main.get_instance_id()
	var player: Node = main.get_node("MainLevel/Player")
	var manager: Node = main.get_node("MainLevel/EnemyManager")
	var enemy: Node = (manager.get(&"predators") as Array)[0]
	root.get_node("EventBus").emit_signal(&"battle_requested", player, enemy)
	await _frames(1)
	player.get(&"cell_health_component").call(&"reduce_health", 9999.0)
	await _frames(3)
	_check(
		"lose: lose screen is the current scene",
		current_scene != null and current_scene.name == "LoseGameScreen",
		"current=%s" % current_scene
	)
	_check(
		"lose: game scene freed",
		instance_from_id(main_id) == null,
		"main alive=%s" % (instance_from_id(main_id) != null)
	)
	await _clear_scene()


func _test_win() -> void:
	var main: Node = await _spawn_main()
	var main_id: int = main.get_instance_id()
	var manager: Node = main.get_node("MainLevel/EnemyManager")
	var counter: RichTextLabel = main.get_node("MainUi").get(&"eaten_counter_text")
	var goal: int = manager.get(&"predators_to_win")
	_check(
		"win: counter starts at zero",
		counter.text.contains("0/%d" % goal),
		"text=%s" % counter.text
	)
	manager.set(&"predators_to_win", 2)
	(manager.get(&"predators") as Array)[0].get(&"cell_health_component").call(&"die")
	await _frames(1)
	_check(
		"win: eating a predator updates the counter",
		counter.text.contains("1/2"),
		"text=%s" % counter.text
	)
	_check("win: no win after one of two", current_scene == main, "current=%s" % current_scene)
	(manager.get(&"predators") as Array)[0].get(&"cell_health_component").call(&"die")
	await _frames(3)
	_check(
		"win: win screen after eating the goal",
		current_scene != null and current_scene.name == "WinGameScreen",
		"current=%s" % current_scene
	)
	_check(
		"win: game scene freed",
		instance_from_id(main_id) == null,
		"main alive=%s" % (instance_from_id(main_id) != null)
	)
	await _clear_scene()


func _test_start_balance() -> void:
	var too_strong: int = 0
	var too_close: int = 0
	var runs: int = 15
	for r: int in runs:
		var main: Node = await _spawn_main()
		var player: Node2D = main.get_node("MainLevel/Player")
		var manager: Node = main.get_node("MainLevel/EnemyManager")
		var radius: float = manager.get(&"safe_spawn_radius")
		for enemy: Node2D in manager.get(&"predators"):
			if (
				int(enemy.get(&"cell_strength_value")) > 1
				or int(enemy.get(&"cell_immune_value")) > 1
				or int(enemy.get(&"cell_swiftness_value")) > 1
			):
				too_strong += 1
			if enemy.global_position.distance_to(player.global_position) < radius:
				too_close += 1
		await _clear_scene()
	_check(
		"balance: starting predators are not stronger than the player",
		too_strong == 0,
		"stronger=%d" % too_strong
	)
	_check(
		"balance: no predator spawns inside the safe radius",
		too_close == 0,
		"too close=%d" % too_close
	)

	var main: Node = await _spawn_main()
	var health: Node = main.get_node("MainLevel/Player").get(&"cell_health_component")
	health.set(&"cell_current_health", 1.0)
	await _frames(180)
	_check(
		"balance: player regenerates out of battle",
		float(health.get(&"cell_current_health")) > 1.0,
		"hp=%.1f" % health.get(&"cell_current_health")
	)
	await _clear_scene()


func _test_sprite_scale_drift() -> void:
	var main: Node = await _spawn_main()
	var sprite: Node2D = main.get_node("MainLevel/Player/PlayerAnimatedSpriteComponent")
	var base: Vector2 = sprite.scale
	var lo: float = sprite.get(&"min_sprite_scale")
	var hi: float = sprite.get(&"max_sprite_scale")
	for i: int in 300:
		sprite.call(&"change_scale_parameters")
		var tween: Tween = sprite.get(&"scale_tween")
		tween.custom_step(100.0)
	var ratio: float = sprite.scale.x / base.x
	_check(
		"sprite: breathing scale stays around the base",
		ratio >= lo - 0.001 and ratio <= hi + 0.001,
		"scale/base=%.3f allowed [%.2f, %.2f]" % [ratio, lo, hi]
	)
	await _clear_scene()


func _test_navigation() -> void:
	change_scene_to_file(MAIN_MENU_PATH)
	await _frames(3)
	current_scene.find_child("StartGameButton", true, false).emit_signal(&"pressed")
	await _frames(3)
	_check(
		"nav: main menu -> tutorial",
		current_scene != null and current_scene.name == "TutorialMenu",
		"current=%s" % current_scene
	)
	current_scene.get_node("Button").emit_signal(&"pressed")
	await _frames(3)
	_check(
		"nav: tutorial -> game",
		current_scene != null and current_scene.name == "MainScene",
		"current=%s" % current_scene
	)
	var main_id: int = current_scene.get_instance_id()
	_press(current_scene, &"pause_game")
	await _frames(1)
	(
		current_scene
		. find_child("PauseMenu", true, false)
		. find_child("MainMenuButton", true, false)
		. emit_signal(&"pressed")
	)
	await _frames(3)
	_check(
		"nav: pause -> main menu frees the game",
		(
			current_scene != null
			and current_scene.name == "MainMenu"
			and instance_from_id(main_id) == null
		),
		"current=%s main alive=%s" % [current_scene, instance_from_id(main_id) != null]
	)
	_check("nav: main menu is not left paused", not paused, "paused=%s" % paused)

	change_scene_to_file("res://Assets/Scenes/UI/AfterGameScreens/LoseGameScreen.tscn")
	await _frames(3)
	current_scene.find_child("RestartGameButton", true, false).emit_signal(&"pressed")
	await _frames(3)
	_check(
		"nav: lose -> restart -> tutorial",
		current_scene != null and current_scene.name == "TutorialMenu",
		"current=%s" % current_scene
	)
	change_scene_to_file("res://Assets/Scenes/UI/AfterGameScreens/WinGameScreen.tscn")
	await _frames(3)
	current_scene.find_child("MainMenuButton", true, false).emit_signal(&"pressed")
	await _frames(3)
	_check(
		"nav: win -> main menu",
		current_scene != null and current_scene.name == "MainMenu",
		"current=%s" % current_scene
	)
	_check(
		"nav: only one screen in the tree",
		root.get_child_count() == 2,
		"root=%s" % [root.get_children()]
	)
	await _clear_scene()


func _test_background_parallax() -> void:
	var main: Node = await _spawn_main()
	var background: Sprite2D = main.get_node("MainLevel").get(&"main_background")
	var view: Vector2 = main.get_node("MainLevel").get_viewport_rect().size
	# Only the background is under test: keep predators out of the way
	main.get_node("MainLevel/EnemyManager").process_mode = Node.PROCESS_MODE_DISABLED
	var worst: Array[String] = []
	for action: StringName in [&"move_right", &"move_down", &"move_left", &"move_up"]:
		Input.action_press(action)
		await _frames(600)
		Input.action_release(action)
		var half: Vector2 = background.texture.get_size() * background.scale / 2.0
		var rect: Rect2 = Rect2(background.position - half, half * 2.0)
		if not rect.encloses(Rect2(Vector2.ZERO, view)):
			worst.append("%s: bg rect %s" % [action, rect])
	_check("background: edges never enter the screen", worst.is_empty(), "problems=%s" % [worst])
	await _clear_scene()


func _test_overlap_after_battle() -> void:
	var main: Node = await _spawn_main()
	var player: Node2D = main.get_node("MainLevel/Player")
	var enemies: Array = main.get_node("MainLevel/EnemyManager").get(&"predators")
	var first: Node2D = enemies[0]
	var second: Node2D = enemies[1]
	for other: Node2D in enemies.slice(2):
		other.global_position = Vector2(100, 100)
	player.get(&"cell_health_component").set(&"cell_current_defense", 1000)
	first.get(&"cell_health_component").set(&"cell_current_health", 0.1)
	second.get(&"cell_movement_component").process_mode = Node.PROCESS_MODE_DISABLED
	first.global_position = player.global_position + Vector2(5, 0)
	for i: int in 60:
		await process_frame
		if player.get(&"cell_auto_battle_component").get(&"target_cell") == first:
			break
	second.global_position = player.global_position + Vector2(-5, 0)
	var first_id: int = first.get_instance_id()
	for i: int in 600:
		await process_frame
		if instance_from_id(first_id) == null:
			break
	await _frames(10)
	var target: Variant = player.get(&"cell_auto_battle_component").get(&"target_cell")
	_check(
		"battle: a cell already touching the player fights next",
		instance_from_id(first_id) == null and target == second,
		"first dead=%s target=%s" % [instance_from_id(first_id) == null, target]
	)
	await _clear_scene()


func _test_no_evolve_in_battle() -> void:
	var main: Node = await _spawn_main()
	var player: Node2D = main.get_node("MainLevel/Player")
	var enemy: Node = (main.get_node("MainLevel/EnemyManager").get(&"predators") as Array)[0]
	enemy.get(&"cell_health_component").set(&"cell_current_health", 1000.0)
	root.get_node("EventBus").emit_signal(&"money_earned", 50)
	root.get_node("EventBus").emit_signal(&"battle_requested", player, enemy)
	await _frames(2)
	var evolve: Node = player.get(&"player_evolve_component")
	_press(evolve, &"try_evolve")
	await _frames(2)
	var cards_ui: Node = main.get_node("MainUi").find_child("PlayerEvolveCardsUi", true, false)
	_check(
		"battle: E does nothing during a fight",
		cards_ui == null and player.process_mode == Node.PROCESS_MODE_INHERIT,
		"cards=%s player mode=%d" % [cards_ui, player.process_mode]
	)
	await _clear_scene()


func _test_pause_toggle() -> void:
	var main: Node = await _spawn_main()
	var enemy: Node2D = (main.get_node("MainLevel/EnemyManager").get(&"predators") as Array)[0]
	var pause_menu: CanvasItem = main.find_child("PauseMenu", true, false)
	_press(main, &"pause_game")
	await _frames(1)
	var position_paused: Vector2 = enemy.global_position
	await _frames(120)
	_check(
		"pause: Esc pauses the level and shows the menu",
		paused and pause_menu.visible and enemy.global_position == position_paused,
		(
			"paused=%s menu=%s moved=%s"
			% [paused, pause_menu.visible, enemy.global_position != position_paused]
		)
	)
	_press(main, &"pause_game")
	await _frames(2)
	_check(
		"pause: Esc again resumes",
		not paused and not pause_menu.visible,
		"paused=%s menu=%s" % [paused, pause_menu.visible]
	)
	await _clear_scene()


func _test_menus_and_settings() -> void:
	var settings_path: String = "user://settings.cfg"
	var had_settings: bool = FileAccess.file_exists(settings_path)
	var saved_settings: String = (
		FileAccess.get_file_as_string(settings_path) if had_settings else ""
	)
	var locale_before: String = TranslationServer.get_locale()

	change_scene_to_file(MAIN_MENU_PATH)
	await _frames(3)
	var menu: Node = current_scene
	var ru: Button = menu.find_child("RULanguageButton", true, false)
	var en: Button = menu.find_child("ENLanguageButton", true, false)
	_check(
		"menu: language buttons are visible",
		ru.size.y > 10 and en.size.y > 10 and ru.is_visible_in_tree(),
		"ru=%s en=%s" % [ru.size, en.size]
	)
	ru.emit_signal(&"pressed")
	_check(
		"menu: RU button switches the language",
		TranslationServer.get_locale().begins_with("ru"),
		"locale=%s" % TranslationServer.get_locale()
	)
	var master: HSlider = menu.find_child("MasterProgressBar", true, false)
	master.value = 0.42
	var labels_ok: bool = true
	for label: Node in menu.find_children("RichTextLabel", "RichTextLabel", true, false):
		if (
			(label as RichTextLabel).text.begins_with("SETTINGS_")
			and (label as Control).size.x < 20
		):
			labels_ok = false
	_check("menu: volume labels have text and width", labels_ok, "ok=%s" % labels_ok)
	_check("menu: quit button exists", menu.find_child("QuitGameButton", true, false) != null, "")

	# Simulate a restart: reset the live values, then load what was saved
	TranslationServer.set_locale("en")
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), 1.0)
	GameSettings.load_and_apply()
	_check(
		"settings: language and volume survive a restart",
		(
			TranslationServer.get_locale().begins_with("ru")
			and is_equal_approx(GameSettings.get_bus_volume("Master"), 0.42)
		),
		(
			"locale=%s master=%.2f"
			% [TranslationServer.get_locale(), GameSettings.get_bus_volume("Master")]
		)
	)
	en.emit_signal(&"pressed")

	menu.find_child("StartGameButton", true, false).emit_signal(&"pressed")
	await _frames(3)
	var controls: RichTextLabel = current_scene.get(&"controls_text")
	_check(
		"tutorial: controls line names the keys",
		controls.text.contains("WASD") and controls.text.contains("E"),
		"text=%s" % controls.text
	)
	var empty_images: int = 0
	for rect: Node in current_scene.find_children("*", "TextureRect", true, false):
		if (rect as TextureRect).texture == null:
			empty_images += 1
	_check("tutorial: no empty images", empty_images == 0, "empty=%d" % empty_images)

	var main: Node = await _spawn_main()
	var bars_without_texture: int = 0
	for bar: Node in main.find_children("*", "TextureProgressBar", true, false):
		if (bar as TextureProgressBar).texture_progress == null:
			bars_without_texture += 1
	_check(
		"hud: progress bars have textures",
		bars_without_texture == 0,
		"missing=%d" % bars_without_texture
	)
	var hint: RichTextLabel = main.get_node("MainUi").get(&"player_can_evolve_text")
	_check("hud: evolve hint names the key", hint.text.contains("E"), "text=%s" % hint.text)
	await _clear_scene()

	# Leave the machine as it was
	if had_settings:
		var file: FileAccess = FileAccess.open(settings_path, FileAccess.WRITE)
		file.store_string(saved_settings)
		file.close()
	else:
		DirAccess.remove_absolute(ProjectSettings.globalize_path(settings_path))
	TranslationServer.set_locale(locale_before)
