extends Reference

const THRESHOLD = 3.0


static func is_evolution_fruit(data: Resource) -> bool:
	return data != null and (data.my_id_hash == Keys.consumable_meca_fruit_hash or data.my_id_hash == Keys.consumable_mutant_fruit_hash)


static func can_attract(data: Resource, player_index: int) -> bool:
	if not is_evolution_fruit(data) or player_index < 0 or player_index >= RunData.get_player_count():
		return false
	if abs(RunData.get_player_effect(Keys.stat_evolution_hash, player_index)) < THRESHOLD:
		return false
	return RunData.can_pick_up_consumable(data, player_index)
