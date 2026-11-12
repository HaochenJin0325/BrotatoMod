extends "res://main.gd"


func on_levelled_up(player_index: int) -> void:
	.on_levelled_up(player_index)
	if not RunData.is_endless_run or RunData.current_wave <= RunData.nb_of_waves:
		return
	# Preserve the source mod's pickup-range-based material bonus, but only in Endless after wave 20.
	RunData.add_gold(max(0, RunData.get_player_effect(Keys.pickup_range_hash, player_index) / 2), player_index)