extends Node

const MOD_DIR_NAME := "BrotatoMod-EndlessUnlimitedPickupRange"
const MOD_ID := MOD_DIR_NAME


func _init() -> void:
	var mod_dir_path: String = ModLoaderMod.get_unpacked_dir().plus_file(MOD_DIR_NAME)
	for extension_path in [
		"extensions/main/main.gd",
		"extensions/entities/units/player/player.gd"
	]:
		ModLoaderMod.install_script_extension(mod_dir_path.plus_file(extension_path))
	ModLoaderLog.info("Loaded; unlimited pickup range activates after wave 20 in Endless mode.", MOD_ID)