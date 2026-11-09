extends Node

const MOD_DIR_NAME := "BrotatoMod-FreeShopRefresh"
const MOD_ID := "BrotatoMod-FreeShopRefresh"

func _init() -> void:
	var mod_dir_path: String = ModLoaderMod.get_unpacked_dir().plus_file(MOD_DIR_NAME)
	var extensions_dir_path: String = mod_dir_path.plus_file("extensions")
	ModLoaderMod.install_script_extension(
		extensions_dir_path.plus_file("singletons/item_service.gd")
	)
	ModLoaderMod.install_script_extension(
		extensions_dir_path.plus_file("ui/menus/ingame/upgrades_ui_player_container.gd")
	)
	ModLoaderLog.info("Loaded; shop and upgrade rerolls are free.", MOD_ID)
