extends "res://singletons/player_run_data.gd"

const HeroEditorRules = preload("res://mods-unpacked/BrotatoMod-HeroEditor/hero_editor_rules.gd")


func deserialize(data: Dictionary) -> PlayerRunData:
	.deserialize(data)
	var character_id: String = str(data.get("current_character", ""))
	if HeroEditorRules.is_fusion_id(character_id):
		current_character = HeroEditorRules.make_fusion_from_id(character_id)
		if current_character != null:
			var found_character: bool = false
			for item in items:
				if item.my_id == current_character.my_id:
					found_character = true
					break
			if not found_character:
				items.push_back(current_character)
	return self
