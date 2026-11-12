extends "res://main.gd"


func on_item_box_ban_button_pressed(item_data: ItemParentData, consumable: UpgradesUI.ConsumableToProcess) -> void:
	var player_index = consumable.player_index
	var value = ItemService.get_item_box_recycling_value(RunData.current_wave, item_data.value, player_index, item_data is WeaponData)
	var player_run_data = RunData.players_data[player_index]
	player_run_data.banned_items.push_back(item_data.my_id_hash)
	RunData.add_gold(value, player_index)
	RunData.update_recycling_tracking_value(item_data, player_index)