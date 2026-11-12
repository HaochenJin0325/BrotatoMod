extends "res://entities/units/player/player.gd"

const MAGNET_RANGE = 5000

var _magnet_enabled = false
var _magnet_label
var _attract_timer: float = 0.0
var _endless_pickup_active = false
var _range_needs_sync = true
var _range_modified_by_mod = false


# Godot/ModLoader invokes each extension layer's lifecycle callbacks independently.
func _ready():
	if get_node("/root").has_meta("magnet_enabled"):
		_magnet_enabled = get_node("/root").get_meta("magnet_enabled")
	else:
		_magnet_enabled = true
		get_node("/root").set_meta("magnet_enabled", true)
	_sync_endless_pickup_mode()


func _physics_process(delta: float) -> void:
	_sync_endless_pickup_mode()
	if not _endless_pickup_active or not _magnet_enabled:
		return
	_attract_timer += delta
	if _attract_timer >= 0.1:
		_attract_timer = 0.0
		_attract_all_items()


func _sync_endless_pickup_mode() -> void:
	var should_be_active: bool = RunData.is_endless_run and RunData.current_wave > RunData.nb_of_waves
	if should_be_active != _endless_pickup_active:
		_endless_pickup_active = should_be_active
		_range_needs_sync = true
		if _endless_pickup_active:
			_ensure_magnet_label()
			_magnet_label.show()
			_update_label()
		elif is_instance_valid(_magnet_label):
			_magnet_label.hide()

	if not _range_needs_sync or not is_instance_valid(_item_attract_area):
		return
	if _endless_pickup_active and _magnet_enabled:
		_item_attract_area.apply_pickup_range_effect(MAGNET_RANGE)
		_range_modified_by_mod = true
	elif _range_modified_by_mod:
		var original_range = RunData.get_player_effect(Keys.pickup_range_hash, player_index)
		_item_attract_area.apply_pickup_range_effect(original_range)
		_range_modified_by_mod = false
	_range_needs_sync = false


func _ensure_magnet_label() -> void:
	if is_instance_valid(_magnet_label):
		return
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100
	add_child(canvas_layer)
	var font = load("res://resources/fonts/actual/base/font_40_outline_thick.tres")
	var theme = load("res://resources/themes/base_theme.tres")
	_magnet_label = Label.new()
	_magnet_label.theme = theme
	_magnet_label.set("custom_fonts/font", font)
	_magnet_label.align = Label.ALIGN_RIGHT
	_magnet_label.anchor_left = 1.0
	_magnet_label.anchor_right = 1.0
	_magnet_label.margin_left = -500
	_magnet_label.margin_right = -50
	_magnet_label.margin_top = 20
	canvas_layer.add_child(_magnet_label)


func _input(event):
	if not RunData.is_endless_run or RunData.current_wave <= RunData.nb_of_waves:
		return
	if event is InputEventKey and event.pressed and not event.echo and event.scancode == KEY_F:
		_magnet_enabled = not _magnet_enabled
		get_node("/root").set_meta("magnet_enabled", _magnet_enabled)
		_range_needs_sync = true
		_update_label()
		_sync_endless_pickup_mode()


func _attract_all_items() -> void:
	if not is_instance_valid(_item_attract_area) or not _item_attract_area.monitoring:
		return
	for area in _item_attract_area.get_overlapping_areas():
		if area is Item and area.attracted_by != self:
			_on_ItemAttractArea_area_entered(area)


func _update_label() -> void:
	if not is_instance_valid(_magnet_label):
		return
	if _magnet_enabled:
		_magnet_label.text = "Magnet: Enabled"
		_magnet_label.set("custom_colors/font_color", Color(0.2, 1.0, 0.2))
	else:
		_magnet_label.text = "Magnet: Disabled"
		_magnet_label.set("custom_colors/font_color", Color(1.0, 0.3, 0.3))