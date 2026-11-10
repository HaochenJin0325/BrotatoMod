extends "res://ui/menus/run/character_selection.gd"

const HeroEditorRules = preload("res://mods-unpacked/BrotatoMod-HeroEditor/hero_editor_rules.gd")
const HeroEditorPassiveFont = preload("res://resources/fonts/actual/base/font_very_smallest_text.tres")

var _hero_editor_dialog: ConfirmationDialog
var _hero_editor_first: OptionButton
var _hero_editor_second: OptionButton
var _hero_editor_parent_options: Array = []
var _hero_editor_pending_player: int = -1
var _hero_editor_first_preview: Dictionary = {}
var _hero_editor_second_preview: Dictionary = {}
var _hero_editor_fusion_preview: Dictionary = {}
var _hero_editor_parent_grid: GridContainer
var _hero_editor_scroll: ScrollContainer
var _hero_editor_content: VBoxContainer


func _get_all_possible_elements(player_index: int) -> Array:
	var elements: Array = ._get_all_possible_elements(player_index)
	var editor_row: CharacterData = HeroEditorRules.make_editor_row()
	if editor_row != null:
		elements.push_back(editor_row)
	return elements


func _get_unlocked_elements(player_index: int) -> Array:
	var unlocked: Array = ._get_unlocked_elements(player_index).duplicate()
	var editor_hash: int = Keys.generate_hash("character_hero_editor")
	if not unlocked.has(editor_hash):
		unlocked.push_back(editor_hash)
	return unlocked


func _on_element_pressed(element: InventoryElement, inventory_player_index: int) -> void:
	var player_index: int = FocusEmulatorSignal.get_player_index(element)
	if player_index < 0:
		return

	if element.item is CharacterData and HeroEditorRules.is_editor_row(element.item):
		_open_hero_editor_dialog(player_index)
		return

	if element.is_random:
		var available_elements: Array = []
		for candidate in displayed_elements[0]:
			if candidate is CharacterData and HeroEditorRules.is_editor_row(candidate):
				continue
			if not candidate.is_locked and _get_item_disabled_update(candidate) == null:
				available_elements.push_back(candidate)
		_player_characters[player_index] = Utils.get_rand_element(available_elements)
	elif element.is_special:
		return
	else:
		_player_characters[player_index] = null
		_on_element_focused(element, inventory_player_index)
		_player_characters[player_index] = element.item

	_set_selected_element(player_index)


func _open_hero_editor_dialog(player_index: int) -> void:
	_hero_editor_parent_options.clear()
	for character in ItemService.characters:
		if not ProgressData.characters_unlocked.has(character.my_id_hash) and not DebugService.unlock_all_chars:
			continue
		if _get_item_disabled_update(character) != null:
			continue
		_hero_editor_parent_options.push_back(character)
	if _hero_editor_parent_options.empty():
		return

	_hero_editor_pending_player = player_index
	if _hero_editor_dialog != null and is_instance_valid(_hero_editor_dialog):
		_hero_editor_dialog.queue_free()

	_hero_editor_dialog = ConfirmationDialog.new()
	_hero_editor_dialog.window_title = "角色合成"
	_hero_editor_dialog.get_ok().text = "合成"
	_hero_editor_dialog.get_cancel().text = "取消"
	_hero_editor_dialog.rect_min_size = Vector2(1200, 900)

	_hero_editor_scroll = ScrollContainer.new()
	_hero_editor_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_hero_editor_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_hero_editor_scroll.scroll_horizontal_enabled = false
	_hero_editor_dialog.add_child(_hero_editor_scroll)

	_hero_editor_content = VBoxContainer.new()
	_hero_editor_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_hero_editor_content.add_constant_override("separation", 12)
	_hero_editor_scroll.add_child(_hero_editor_content)

	var title := Label.new()
	title.text = "选择两个已解锁角色，查看双方被动与合成结果。"
	_hero_editor_content.add_child(title)

	_hero_editor_parent_grid = GridContainer.new()
	_hero_editor_parent_grid.columns = 2
	_hero_editor_parent_grid.add_constant_override("hseparation", 12)
	_hero_editor_parent_grid.add_constant_override("vseparation", 8)
	_hero_editor_parent_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_hero_editor_parent_grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_hero_editor_content.add_child(_hero_editor_parent_grid)
	_hero_editor_first_preview = _create_hero_editor_preview("角色 1", Color(0.9, 0.13, 0.16), true, false)
	_hero_editor_second_preview = _create_hero_editor_preview("角色 2", Color(0.08, 0.68, 0.32), true, false)
	_hero_editor_parent_grid.add_child(_hero_editor_first_preview["panel"])
	_hero_editor_parent_grid.add_child(_hero_editor_second_preview["panel"])
	_hero_editor_first = _hero_editor_first_preview["selector"]
	_hero_editor_second = _hero_editor_second_preview["selector"]

	var fusion_row := HBoxContainer.new()
	_hero_editor_content.add_child(fusion_row)
	_hero_editor_fusion_preview = _create_hero_editor_preview("合成角色预览", Color(0.15, 0.4, 0.98), false, true)
	fusion_row.add_child(_hero_editor_fusion_preview["panel"])

	for character in _hero_editor_parent_options:
		var character_name: String = TranslationServer.translate(character.name)
		_hero_editor_first.add_item(character_name)
		_hero_editor_second.add_item(character_name)

	_hero_editor_first.selected = 0
	_hero_editor_second.selected = 1 if _hero_editor_parent_options.size() > 1 else 0
	_hero_editor_first.connect("item_selected", self, "_on_hero_editor_source_changed")
	_hero_editor_second.connect("item_selected", self, "_on_hero_editor_source_changed")
	_hero_editor_dialog.connect("confirmed", self, "_on_hero_editor_confirmed")
	add_child(_hero_editor_dialog)
	var viewport = get_viewport()
	if viewport != null and not viewport.is_connected("size_changed", self, "_on_hero_editor_viewport_resized"):
		viewport.connect("size_changed", self, "_on_hero_editor_viewport_resized")
	_fit_hero_editor_dialog_to_viewport(false)
	_hero_editor_dialog.popup_centered()
	call_deferred("_refresh_hero_editor_previews")


func _create_hero_editor_preview(title_text: String, accent: Color, with_selector: bool, show_second_icon: bool) -> Dictionary:
	var panel := PanelContainer.new()
	panel.rect_min_size = Vector2(0, 245 if with_selector else 170)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.075, 0.075, 0.075, 0.98)
	panel_style.border_color = accent
	panel_style.set_border_width_all(2)
	panel.add_stylebox_override("panel", panel_style)

	var body := VBoxContainer.new()
	body.add_constant_override("separation", 8)
	panel.add_child(body)

	var heading := Label.new()
	heading.text = title_text
	heading.modulate = accent
	heading.align = Label.ALIGN_CENTER
	body.add_child(heading)

	var selector: OptionButton = null
	if with_selector:
		selector = OptionButton.new()
		selector.rect_min_size.y = 38
		selector.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		body.add_child(selector)

	var identity := HBoxContainer.new()
	identity.add_constant_override("separation", 8)
	body.add_child(identity)
	var first_icon := TextureRect.new()
	first_icon.rect_min_size = Vector2(78, 78)
	first_icon.expand = true
	first_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	identity.add_child(first_icon)

	var second_icon: TextureRect = null
	if show_second_icon:
		var plus := Label.new()
		plus.text = "+"
		plus.align = Label.ALIGN_CENTER
		identity.add_child(plus)
		second_icon = TextureRect.new()
		second_icon.rect_min_size = Vector2(78, 78)
		second_icon.expand = true
		second_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		identity.add_child(second_icon)

	var name_label := Label.new()
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_label.autowrap = true
	name_label.valign = Label.VALIGN_CENTER
	identity.add_child(name_label)

	var details := RichTextLabel.new()
	details.rect_min_size.y = 170 if with_selector else 120
	details.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	details.bbcode_enabled = true
	details.scroll_active = true
	details.add_font_override("normal_font", HeroEditorPassiveFont)
	body.add_child(details)

	return {"panel": panel, "selector": selector, "first_icon": first_icon, "second_icon": second_icon, "name": name_label, "details": details}


func _on_hero_editor_source_changed(_selected_index: int) -> void:
	_refresh_hero_editor_previews()


func _on_hero_editor_viewport_resized() -> void:
	_fit_hero_editor_dialog_to_viewport(true)


func _fit_hero_editor_dialog_to_viewport(recenter: bool) -> void:
	if _hero_editor_dialog == null or not is_instance_valid(_hero_editor_dialog):
		return
	var view_size: Vector2 = get_viewport_rect().size
	if view_size.x <= 0 or view_size.y <= 0:
		view_size = OS.get_window_size()
	var dialog_width: float = min(1600.0, max(300.0, view_size.x * 0.96))
	var dialog_height: float = min(960.0, max(280.0, view_size.y * 0.95))
	_hero_editor_dialog.rect_min_size = Vector2(dialog_width, dialog_height)
	_hero_editor_dialog.rect_size = Vector2(dialog_width, dialog_height)
	if _hero_editor_parent_grid != null:
		_hero_editor_parent_grid.columns = 2 if dialog_width >= 640 else 1
	var icon_size: float = clamp(min(dialog_width * 0.09, dialog_height * 0.13), 58.0, 108.0)
	for preview in [_hero_editor_first_preview, _hero_editor_second_preview, _hero_editor_fusion_preview]:
		if preview.empty():
			continue
		preview["first_icon"].rect_min_size = Vector2(icon_size, icon_size)
		if preview["second_icon"] != null:
			preview["second_icon"].rect_min_size = Vector2(icon_size, icon_size)
		preview["panel"].rect_min_size.y = dialog_height * (0.43 if preview["selector"] != null else 0.39)
		preview["details"].rect_min_size.y = dialog_height * 0.25
	if recenter and _hero_editor_dialog.visible:
		_hero_editor_dialog.popup_centered()


func _refresh_hero_editor_previews() -> void:
	if _hero_editor_parent_options.empty() or _hero_editor_first == null or _hero_editor_second == null:
		return
	var first_index: int = clamp(_hero_editor_first.selected, 0, _hero_editor_parent_options.size() - 1)
	var second_index: int = clamp(_hero_editor_second.selected, 0, _hero_editor_parent_options.size() - 1)
	var first: CharacterData = _hero_editor_parent_options[first_index]
	var second: CharacterData = _hero_editor_parent_options[second_index]
	var first_passives: String = _get_hero_editor_passive_text(first.effects)
	var second_passives: String = _get_hero_editor_passive_text(second.effects)
	_update_hero_editor_preview(_hero_editor_first_preview, first, first_passives)
	_update_hero_editor_preview(_hero_editor_second_preview, second, second_passives)
	_update_hero_editor_fusion_preview(_hero_editor_fusion_preview, first, second, first_passives, second_passives)


func _update_hero_editor_preview(preview: Dictionary, character: CharacterData, passive_text: String) -> void:
	preview["first_icon"].texture = character.icon
	preview["name"].text = TranslationServer.translate(character.name)
	preview["details"].bbcode_text = passive_text if passive_text != "" else "无被动效果"


func _update_hero_editor_fusion_preview(preview: Dictionary, first: CharacterData, second: CharacterData, first_passives: String, second_passives: String) -> void:
	preview["first_icon"].texture = first.icon
	preview["second_icon"].texture = second.icon
	preview["name"].text = "%s + %s" % [TranslationServer.translate(first.name), TranslationServer.translate(second.name)]
	var lines: PoolStringArray = PoolStringArray()
	for line in first_passives.split("\n", false):
		lines.append(line)
	for line in second_passives.split("\n", false):
		lines.append(line)
	preview["details"].bbcode_text = lines.join("\n") if lines.size() > 0 else "无被动效果"


func _get_hero_editor_passive_text(effects: Array) -> String:
	var lines: PoolStringArray = PoolStringArray()
	for effect in effects:
		if effect == null or effect is EffectOption:
			continue
		match effect.custom_key_hash:
			Keys.starting_weapon_hash, Keys.starting_item_hash, Keys.cursed_starting_item_hash, Keys.cursed_starting_weapon_hash:
				continue
		var effect_text: String = effect.get_text(_hero_editor_pending_player, false)
		if effect_text != "" and effect_text != "[EMPTY]":
			lines.append("• " + effect_text)
	return lines.join("\n")

func _on_hero_editor_confirmed() -> void:
	if _hero_editor_pending_player < 0 or _hero_editor_parent_options.empty():
		return
	var first_index: int = _hero_editor_first.selected
	var second_index: int = _hero_editor_second.selected
	var first: CharacterData = _hero_editor_parent_options[first_index]
	var second: CharacterData = _hero_editor_parent_options[second_index]
	var fusion: CharacterData = HeroEditorRules.make_fusion(first, second)
	if fusion == null:
		return

	_player_characters[_hero_editor_pending_player] = fusion
	_get_panels()[_hero_editor_pending_player].set_data(fusion, _hero_editor_pending_player)
	_set_selected_element(_hero_editor_pending_player)
	_hero_editor_pending_player = -1
