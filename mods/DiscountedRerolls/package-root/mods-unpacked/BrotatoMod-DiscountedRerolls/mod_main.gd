extends Node

const MOD_DIR_NAME := "BrotatoMod-DiscountedRerolls"
const MOD_ID := "BrotatoMod-DiscountedRerolls"


func _init() -> void:
	var mod_dir_path: String = ModLoaderMod.get_unpacked_dir().plus_file(MOD_DIR_NAME)
	var extension_path: String = mod_dir_path.plus_file("extensions/singletons/item_service.gd")
	ModLoaderMod.install_script_extension(extension_path)
	ModLoaderLog.info("Loaded; shop and upgrade reroll prices are reduced by 60%.", MOD_ID)
