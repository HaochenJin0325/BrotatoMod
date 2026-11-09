extends Node

const MOD_DIR_NAME := "BrotatoMod-AllStartingWeapons"
const MOD_ID := MOD_DIR_NAME


func _init() -> void:
	var mod_dir_path: String = ModLoaderMod.get_unpacked_dir().plus_file(MOD_DIR_NAME)
	var extensions_dir_path: String = mod_dir_path.plus_file("extensions")
	ModLoaderMod.install_script_extension(
		extensions_dir_path.plus_file("ui/menus/run/weapon_selection.gd")
	)
	ModLoaderLog.info("Loaded; weapons from all available tiers and enabled DLC are available at run start.", MOD_ID)
