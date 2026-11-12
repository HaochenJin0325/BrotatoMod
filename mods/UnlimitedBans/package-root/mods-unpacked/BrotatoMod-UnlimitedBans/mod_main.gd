extends Node

const MOD_DIR_NAME := "BrotatoMod-UnlimitedBans"
const MOD_ID := MOD_DIR_NAME


func _init() -> void:
	var mod_dir_path: String = ModLoaderMod.get_unpacked_dir().plus_file(MOD_DIR_NAME)
	for extension_path in [
		"extensions/main.gd",
		"extensions/ui/menus/shop/shop_item.gd",
		"extensions/ui/menus/ingame/upgrades_ui_player_container.gd"
	]:
		ModLoaderMod.install_script_extension(mod_dir_path.plus_file(extension_path))
	ModLoaderLog.info("Loaded; banning items no longer consumes ban uses.", MOD_ID)