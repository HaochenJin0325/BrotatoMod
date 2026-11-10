extends Node

const MOD_DIR_NAME := "BrotatoMod-HeroEditor"
const MOD_ID := MOD_DIR_NAME


func _init() -> void:
	var mod_dir_path: String = ModLoaderMod.get_unpacked_dir().plus_file(MOD_DIR_NAME)
	var extensions_dir_path: String = mod_dir_path.plus_file("extensions")
	for extension_path in [
		"ui/menus/run/character_selection.gd",
		"ui/menus/run/difficulty_selection/difficulty_selection.gd",
		"singletons/player_run_data.gd",
		"singletons/run_data.gd"
	]:
		ModLoaderMod.install_script_extension(extensions_dir_path.plus_file(extension_path))
	ModLoaderLog.info("Loaded; choose Hero Editor to fuse two unlocked characters for one run.", MOD_ID)
