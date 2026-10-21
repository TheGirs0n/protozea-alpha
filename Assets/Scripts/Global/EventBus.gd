extends Node

# --- Экономика ---
signal money_earned(amount: int)

# --- Враги и победа ---
signal predator_eaten(eaten: int, goal: int)
signal game_won()

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
signal player_resume_requested()

# --- Навигация ---
signal continue_requested()
