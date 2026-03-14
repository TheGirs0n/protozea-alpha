extends Control
class_name AutoBattleUi

@export_group("Player Text")
@export var player_damage_text : RichTextLabel
@export var player_defense_text : RichTextLabel
@export var player_endurance_text : RichTextLabel
@export_subgroup("Player Progress Bars")
@export var player_endurance_progress_bar : TextureProgressBar
@export var player_health_progress_bar : TextureProgressBar
@export_subgroup("Player Progress Bars Texts")
@export var player_health_progress_bar_text : RichTextLabel
@export var player_endurance_progress_bar_text : RichTextLabel

@export_group("Enemy Text")
@export var enemy_damage_text : RichTextLabel
@export var enemy_defense_text : RichTextLabel
@export var enemy_endurance_text : RichTextLabel
@export_subgroup("Enemy Progress Bars")
@export var enemy_endurance_progress_bar : TextureProgressBar
@export var enemy_health_progress_bar : TextureProgressBar
@export_subgroup("Enemy Progress Bars Texts")
@export var enemy_health_progress_bar_text : RichTextLabel
@export var enemy_endurance_progress_bar_text : RichTextLabel


var _player : BaseCell = null
var _enemy : BaseCell = null


func setup_battle_ui(player: BaseCell, enemy: BaseCell) -> void:
	_player = player
	_enemy = enemy

	player_damage_text.text = str(player.cell_auto_battle_component.cell_current_damage)
	player_defense_text.text = str(player.cell_health_component.cell_current_defense)
	enemy_damage_text.text = str(enemy.cell_auto_battle_component.cell_current_damage)
	enemy_defense_text.text = str(enemy.cell_health_component.cell_current_defense)

	player_health_progress_bar.max_value = player.cell_health_component.cell_max_health
	player_health_progress_bar.value = player.cell_health_component.cell_current_health
	player_health_progress_bar_text.text = str(player_health_progress_bar.value) + "/" + str(player_health_progress_bar.max_value)

	enemy_health_progress_bar.max_value = enemy.cell_health_component.cell_max_health
	enemy_health_progress_bar.value = enemy.cell_health_component.cell_current_health
	enemy_health_progress_bar_text.text = str(enemy_health_progress_bar.value) + "/" + str(enemy_health_progress_bar.max_value)

	player_endurance_progress_bar.max_value = player.cell_auto_battle_component.cell_max_endurance
	player_endurance_progress_bar.value = 0
	player_endurance_text.text = "0.0"
	player_endurance_progress_bar_text.text = str(player_endurance_progress_bar.value) + "/" + str(player_endurance_progress_bar.max_value)

	enemy_endurance_progress_bar.max_value = enemy.cell_auto_battle_component.cell_max_endurance
	enemy_endurance_progress_bar.value = 0
	enemy_endurance_text.text = "0.0"
	enemy_endurance_progress_bar_text.text = str(enemy_endurance_progress_bar.value) + "/" + str(enemy_endurance_progress_bar.max_value)
	
	player.cell_health_component.health_changed.connect(_on_player_health_changed)
	enemy.cell_health_component.health_changed.connect(_on_enemy_health_changed)
	player.cell_auto_battle_component.endurance_changed.connect(set_player_endurance_new_value)
	enemy.cell_auto_battle_component.endurance_changed.connect(set_enemy_endurance_new_value)

	visible = true
	
	
func hide_battle_ui() -> void:
	# Отписываемся перед скрытием
	if _player:
		_player.cell_health_component.health_changed.disconnect(_on_player_health_changed)
		_player.cell_auto_battle_component.endurance_changed.disconnect(set_player_endurance_new_value)
	if _enemy:
		_enemy.cell_health_component.health_changed.disconnect(_on_enemy_health_changed)
		_enemy.cell_auto_battle_component.endurance_changed.disconnect(set_enemy_endurance_new_value)

	_player = null
	_enemy = null
	visible = false


func _on_player_health_changed(new_value: float) -> void:
	player_health_progress_bar.value = new_value
	player_health_progress_bar_text.text = str(player_health_progress_bar.value) + "/" + str(player_health_progress_bar.max_value)

func _on_enemy_health_changed(new_value: float) -> void:
	enemy_health_progress_bar.value = new_value
	enemy_health_progress_bar_text.text = str(enemy_health_progress_bar.value) + "/" + str(enemy_health_progress_bar.max_value)

func set_player_endurance_new_value(new_value: float) -> void:
	player_endurance_progress_bar.value = new_value
	player_endurance_text.text = str(new_value)
	player_endurance_progress_bar_text.text = str(player_endurance_progress_bar.value) + "/" + str(player_endurance_progress_bar.max_value)

func set_enemy_endurance_new_value(new_value: float) -> void:
	enemy_endurance_progress_bar.value = new_value
	enemy_endurance_text.text = str(new_value)
	enemy_endurance_progress_bar_text.text = str(enemy_endurance_progress_bar.value) + "/" + str(enemy_endurance_progress_bar.max_value)
