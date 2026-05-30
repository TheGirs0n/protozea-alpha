extends Node

# --- Экономика ---
signal money_earned(amount: int)

# --- Враги ---
signal enemy_died(enemy: EnemyCell)
signal all_enemies_cleared()

# --- Бой ---
signal battle_requested(player: BaseCell, enemy: BaseCell)
signal battle_started(player: BaseCell, enemy: BaseCell)
signal battle_ended()

# --- Игрок ---
signal player_died()
signal player_stats_changed(strength: int, immune: int, swiftness: int)

# --- Эволюция ---
signal evolve_strength_requested()
signal evolve_immune_requested()
signal evolve_swiftness_requested()
signal evolve_all_requested()
signal show_evolve_text_requested()
signal player_resume_requested()

# --- Навигация ---
signal continue_requested()
signal go_to_main_menu_requested()

# --- UI ---
signal background_move_requested(direction: Vector2)
