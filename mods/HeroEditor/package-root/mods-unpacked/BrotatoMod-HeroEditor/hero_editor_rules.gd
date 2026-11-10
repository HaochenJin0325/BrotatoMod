extends Reference

const HERO_EDITOR_PREFIX := "character_hero_editor__"


static func is_editor_row(character: CharacterData) -> bool:
	return character != null and character.my_id == "character_hero_editor"


static func is_fusion_id(character_id: String) -> bool:
	return character_id.begins_with(HERO_EDITOR_PREFIX)


static func has_origin(character: CharacterData, origin_id: String) -> bool:
	if character == null:
		return false
	if character.my_id == origin_id:
		return true
	if not is_fusion_id(character.my_id):
		return false
	var parts: PoolStringArray = character.my_id.split("__", false)
	for index in range(1, parts.size()):
		if parts[index] == origin_id:
			return true
	return false


static func make_editor_row() -> CharacterData:
	if ItemService.characters.empty():
		return null

	var character: CharacterData = _copy_character(ItemService.characters[0])
	character.my_id = "character_hero_editor"
	character.my_id_hash = Keys.generate_hash(character.my_id)
	Keys.hash_to_string[character.my_id_hash] = character.my_id
	character.name = "Hero Editor"
	character.description = "Choose two unlocked characters to fuse for this run."
	character.effects = []
	character.item_appearances = []
	character.wanted_tags = []
	character.banned_item_groups = []
	character.banned_items = []
	character.banned_upgrades = []
	character.banned_meca_stats = []
	character.starting_weapons = []
	character.starting_items = []
	character.required_item_set = ""
	character.unlocked_by_default = true
	return character


static func make_fusion(first: CharacterData, second: CharacterData) -> CharacterData:
	if first == null or second == null:
		return null

	var fusion: CharacterData = _copy_character(first)
	fusion.my_id = HERO_EDITOR_PREFIX + first.my_id + "__" + second.my_id
	fusion.my_id_hash = Keys.generate_hash(fusion.my_id)
	fusion.name = "%s + %s" % [TranslationServer.translate(first.name), TranslationServer.translate(second.name)]
	fusion.description = "A temporary fusion of two characters."
	fusion.effects = []
	fusion.effects.append_array(first.effects)
	fusion.effects.append_array(second.effects)
	fusion.wanted_tags = _merge_string_arrays(first.wanted_tags, second.wanted_tags)
	fusion.banned_item_groups = _merge_string_arrays(first.banned_item_groups, second.banned_item_groups)
	fusion.banned_items = _merge_string_arrays(first.banned_items, second.banned_items)
	fusion.banned_upgrades = _merge_string_arrays(first.banned_upgrades, second.banned_upgrades)
	fusion.banned_meca_stats = _merge_string_arrays(first.banned_meca_stats, second.banned_meca_stats)
	fusion.starting_weapons = _merge_resources(first.starting_weapons, second.starting_weapons)
	fusion.starting_items = _merge_resources(first.starting_items, second.starting_items)
	fusion.required_item_set = ""
	fusion.unlocked_by_default = true
	return fusion


static func make_fusion_from_id(character_id: String) -> CharacterData:
	if not is_fusion_id(character_id):
		return null
	var parts: PoolStringArray = character_id.split("__", false)
	if parts.size() != 3:
		return null
	var first = _find_character(parts[1])
	var second = _find_character(parts[2])
	return make_fusion(first, second)


static func _copy_character(source: CharacterData) -> CharacterData:
	var copy: CharacterData = CharacterData.new()
	for property_info in source.get_property_list():
		var property_name: String = str(property_info.name)
		if property_name in ["script", "resource_path", "resource_name", "resource_local_to_scene"]:
			continue
		if (int(property_info.usage) & PROPERTY_USAGE_STORAGE) == 0:
			continue
		copy.set(property_name, source.get(property_name))
	copy.my_id_hash = source.my_id_hash
	return copy


static func _find_character(character_id: String) -> CharacterData:
	for character in ItemService.characters:
		if character.my_id == character_id:
			return character
	return null


static func _merge_string_arrays(first: Array, second: Array) -> Array:
	var result: Array = []
	for value in first + second:
		if not result.has(value):
			result.push_back(value)
	return result


static func _merge_resources(first: Array, second: Array) -> Array:
	var result: Array = []
	var ids: Dictionary = {}
	for resource in first + second:
		if resource == null:
			continue
		if not ids.has(resource.my_id_hash):
			ids[resource.my_id_hash] = true
			result.push_back(resource)
	return result
