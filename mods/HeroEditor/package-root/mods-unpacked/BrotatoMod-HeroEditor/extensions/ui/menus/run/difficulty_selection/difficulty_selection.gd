extends "res://ui/menus/run/difficulty_selection/difficulty_selection.gd"

const HeroEditorRules = preload("res://mods-unpacked/BrotatoMod-HeroEditor/hero_editor_rules.gd")


func _get_unlocked_elements(player_index: int) -> Array:
	var unlocked: Array = ._get_unlocked_elements(player_index)
	var fusion_in_run: bool = false
	for player_data in RunData.players_data:
		if player_data.current_character != null and HeroEditorRules.is_fusion_id(player_data.current_character.my_id):
			fusion_in_run = true
			break

	if fusion_in_run:
		for difficulty in ItemService.difficulties:
			if not unlocked.has(difficulty.my_id_hash):
				unlocked.push_back(difficulty.my_id_hash)
	return unlocked
