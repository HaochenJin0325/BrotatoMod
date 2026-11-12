extends "res://ui/menus/ingame/upgrades_ui_player_container.gd"


func show_item(item_data: ItemParentData) -> void:
	.show_item(item_data)
	if not _ban_button.visible:
		return
	var recycling_value: int = ItemService.get_item_box_recycling_value(RunData.current_wave, item_data.value, player_index, item_data is WeaponData)
	_ban_button_label.text = tr("MENU_BAN") + " (∞) (+" + str(recycling_value) + ")"