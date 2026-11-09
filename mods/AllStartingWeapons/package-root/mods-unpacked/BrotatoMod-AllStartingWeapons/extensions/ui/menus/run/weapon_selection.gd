extends "res://ui/menus/run/weapon_selection.gd"


func _get_all_possible_elements(player_index: int) -> Array:
	var possible_weapons: Array = []
	var character = RunData.get_player_character(player_index)
	var no_melee_weapons: bool = RunData.get_player_effect_bool(Keys.no_melee_weapons_hash, player_index)
	var no_ranged_weapons: bool = RunData.get_player_effect_bool(Keys.no_ranged_weapons_hash, player_index)

	for weapon in ItemService.get_weapons():
		if _get_item_disabled_update(weapon) != null:
			continue
		if no_melee_weapons and weapon.type == WeaponType.MELEE:
			continue
		if no_ranged_weapons and weapon.type == WeaponType.RANGED:
			continue
		possible_weapons.push_back(weapon)

	for starting_weapon in character.starting_weapons:
		if not possible_weapons.has(starting_weapon):
			possible_weapons.push_back(starting_weapon)

	var elements: Array = ItemService.get_ordered_starting_weapons(possible_weapons)
	elements.append_array(ItemService.get_ordered_starting_items(character.starting_items))
	return elements


func _get_unlocked_elements(player_index: int) -> Array:
	var weapon_ids: Array = []
	for weapon in _get_all_possible_elements(player_index):
		if weapon is WeaponData or ProgressData.items_unlocked.has(weapon.my_id_hash):
			weapon_ids.push_back(weapon.my_id_hash)
	return weapon_ids
