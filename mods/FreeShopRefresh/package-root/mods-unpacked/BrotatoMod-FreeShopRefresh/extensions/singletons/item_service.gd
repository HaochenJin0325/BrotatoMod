extends "res://singletons/item_service.gd"


func get_reroll_price(wave: int, reroll_count: int, player_index: int) -> Array:
	var result: Array = .get_reroll_price(wave, reroll_count, player_index)
	result[0] = 0
	return result
