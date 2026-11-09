extends "res://ui/menus/ingame/upgrades_ui_player_container.gd"


func show_upgrades_for_level(level: int) -> void:
	.show_upgrades_for_level(level)
	_reroll_price = 0
	_reroll_button.init(0, player_index)
