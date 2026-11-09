extends "res://items/consumables/consumable.gd"

const LOCAL_EP_DROP_RULES = preload("res://mods-unpacked/Local-EvolutionPickup/evolution_pickup.gd")


func drop(pos: Vector2, p_rotation: float, p_push_back_destination: Vector2) -> void:
	.drop(pos, p_rotation, p_push_back_destination)
	if not LOCAL_EP_DROP_RULES.is_evolution_fruit(consumable_data) or not is_inside_tree():
		return
	var main = get_tree().current_scene
	if not is_instance_valid(main) or not main.has_method("_get_shuffled_live_players"):
		return
	# Roll once per drop, just like main.gd's instant_gold_attracting path.
	# Keep the original Consumable and its pickup effects, including pooled reuse.
	for player in main._get_shuffled_live_players():
		if player.dead or player.cleaning_up or not LOCAL_EP_DROP_RULES.can_attract(consumable_data, player.player_index):
			continue
		var chance = RunData.get_player_effect(Keys.instant_gold_attracting_hash, player.player_index)
		if chance > 0 and randf() < chance / 100.0:
			attracted_by = player
			set_physics_process(true)
			break
