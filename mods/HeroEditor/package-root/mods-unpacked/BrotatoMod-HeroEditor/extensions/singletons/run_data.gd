extends "res://singletons/run_data.gd"

const HeroEditorRules = preload("res://mods-unpacked/BrotatoMod-HeroEditor/hero_editor_rules.gd")

func init_elites_spawn(base_wave: int = 10, horde_chance: float = 0.4) -> void :

	if check_elite_generation.has(base_wave):
		return

	var nb_elites = get_nb_elites_per_batch()
	var possible_elites = ZoneService.get_elites_by_camp(current_zone, EliteCamp.NEUTRAL)

	if possible_elites.empty():
		possible_elites = ZoneService.get_elites_from_zone(current_zone)

	for player_index in get_player_count():
		var current_character = get_player_character(player_index)
		if current_character != null:
			if HeroEditorRules.has_origin(current_character, "character_jack") or HeroEditorRules.has_origin(current_character, "character_gangster"):
				horde_chance = 0.0
			elif get_player_count() == 1 and HeroEditorRules.has_origin(current_character, "character_ogre"):
				horde_chance = 1.0

	if nb_elites > 0:
		var wave = Utils.randi_range(base_wave + 1, base_wave + 2)
		for i in nb_elites:

			var type = EliteType.HORDE if Utils.get_chance_success(horde_chance) else EliteType.ELITE

			if DebugService.spawn_specific_elite != "":
				type = EliteType.ELITE
				wave = DebugService.starting_wave
			elif DebugService.spawn_horde:
				type = EliteType.HORDE
				wave = DebugService.starting_wave

			if i == 1:
				wave = Utils.randi_range(base_wave + 4, base_wave + 5)
			elif i == 2:
				wave = Utils.randi_range(base_wave + 7, base_wave + 8)
				type = EliteType.ELITE

			var elite_id = Utils.get_rand_element(possible_elites).my_id_hash if type == EliteType.ELITE else Keys.empty_hash

			for elite in possible_elites:
				if elite.my_id_hash == elite_id:
					possible_elites.erase(elite)
					break

			elites_spawn.push_back([wave, type, elite_id])

	for player_index in get_player_count():
		if get_player_effect(Keys.more_horde_hash, player_index) != 0:
			if base_wave == 10:
				_add_more_horde_waves(9, 10, 1)
			_add_more_horde_waves(base_wave + 1, base_wave + 9, 2)

	check_elite_generation.append(base_wave)
	reorderEliteSpawns()

