extends "res://entities/units/player/player.gd"

const LOCAL_EP_RULES = preload("res://mods-unpacked/Local-EvolutionPickup/evolution_pickup.gd")

var _local_ep_previous_evolution = 0.0


func _on_ItemAttractArea_area_entered(item: Item) -> void:
	if item is Consumable and LOCAL_EP_RULES.is_evolution_fruit(item.consumable_data):
		_local_ep_attract_fruit(item)
		return
	._on_ItemAttractArea_area_entered(item)


func _physics_process(_delta: float) -> void:
	# Godot 3 invokes this notification on every inherited script automatically.
	_local_ep_refresh_threshold()


func _local_ep_refresh_threshold() -> void:
	if dead or cleaning_up or not is_instance_valid(_item_attract_area) or not _item_attract_area.monitoring:
		return
	var evolution = RunData.get_player_effect(Keys.stat_evolution_hash, player_index)
	if evolution == _local_ep_previous_evolution:
		return
	_local_ep_previous_evolution = evolution
	if abs(evolution) < LOCAL_EP_RULES.THRESHOLD:
		return
	# Already-overlapping fruit does not emit area_entered again when the stat changes.
	for item in _item_attract_area.get_overlapping_areas():
		if item is Consumable and LOCAL_EP_RULES.is_evolution_fruit(item.consumable_data):
			_local_ep_attract_fruit(item)


func _local_ep_attract_fruit(item: Consumable) -> void:
	if dead or cleaning_up or item.already_picked_up:
		return
	if not _item_attract_area.monitoring or not _item_attract_area.get_collision_mask_bit(6):
		return
	if not LOCAL_EP_RULES.can_attract(item.consumable_data, player_index):
		return
	# Match material ownership: a closer live player can take over attraction.
	var target = item.attracted_by
	if not is_instance_valid(target) or ("dead" in target and target.dead) or global_position.distance_squared_to(item.global_position) < target.global_position.distance_squared_to(item.global_position):
		item.attracted_by = self
		item.set_physics_process(true)
