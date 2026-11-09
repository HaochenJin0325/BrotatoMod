extends "res://main.gd"

const LOCAL_EP_WAVE_RULES = preload("res://mods-unpacked/Local-EvolutionPickup/evolution_pickup.gd")


func clean_up_room() -> void:
	.clean_up_room()
	_local_ep_attract_remaining_fruit()


func _local_ep_attract_remaining_fruit() -> void:
	var live_players = _get_shuffled_live_players()
	var received = {}
	for item in _consumables:
		if not is_instance_valid(item) or item.already_picked_up or not LOCAL_EP_WAVE_RULES.is_evolution_fruit(item.consumable_data):
			continue
		var eligible_players = []
		for player in live_players:
			if LOCAL_EP_WAVE_RULES.can_attract(item.consumable_data, player.player_index):
				eligible_players.append(player)
		# Use the native fair distribution, restricted to players at the threshold.
		var receiver = _get_least_served_player_able_to_pick_up(item, eligible_players, received)
		if receiver != null:
			received[item.consumable_data.my_id_hash][receiver.player_index] += 1
			item.attracted_by = receiver
			item.set_physics_process(true)


func _on_EndWaveTimer_timeout() -> void:
	# Very large maps can outlast the native two-second collection animation.
	# Finish only eligible evolution fruit before the native shop transition.
	for item in _consumables.duplicate():
		if not is_instance_valid(item) or item.already_picked_up or not LOCAL_EP_WAVE_RULES.is_evolution_fruit(item.consumable_data):
			continue
		var receiver = item.attracted_by
		if is_instance_valid(receiver) and receiver is Player and not receiver.dead and LOCAL_EP_WAVE_RULES.can_attract(item.consumable_data, receiver.player_index):
			item.pickup(receiver.player_index)
	._on_EndWaveTimer_timeout()
