extends "res://ui/menus/shop/shop_item.gd"


func manage_ban_button_visibility() -> void:
	.manage_ban_button_visibility()
	if _ban_button.visible:
		_ban_button.text = Text.text("BAN_SHOP", ["∞"])


func ban_item() -> void:
	var player_run_data = RunData.players_data[player_index]
	player_run_data.banned_items.push_back(item_data.my_id_hash)
	deactivate()
	emit_signal("ban_update_remaining_token")