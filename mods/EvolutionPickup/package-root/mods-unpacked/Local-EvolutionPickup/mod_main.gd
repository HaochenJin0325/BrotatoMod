extends Node

const MOD_DIR = "res://mods-unpacked/Local-EvolutionPickup/"


func _ready() -> void:
	ModLoaderMod.install_script_extension(MOD_DIR + "extensions/player.gd")
	ModLoaderMod.install_script_extension(MOD_DIR + "extensions/consumable.gd")
	ModLoaderMod.install_script_extension(MOD_DIR + "extensions/main.gd")
