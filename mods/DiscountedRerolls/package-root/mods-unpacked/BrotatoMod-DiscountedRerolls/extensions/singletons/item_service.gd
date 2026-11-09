extends "res://singletons/item_service.gd"


func get_reroll_price(wave: int, reroll_count: int, player_index: int) -> Array:
	var result: Array = .get_reroll_price(wave, reroll_count, player_index)
	var original_price: int = result[0]
	var reduced_price: int = int(ceil(float(original_price) * 0.4))
	result[0] = max(1, reduced_price)
	return result
