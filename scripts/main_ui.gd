extends Control
class_name MainUI

@export var queue_manager : QueueManager

@export var _button_last : TextureButton
@export var _button_next : TextureButton
@export var _label_enemy_name : Label
@export var _label_enemy_description : Label
@export var _enemy_health_container : EnemyHealthContainer

@export var _enemy_area2 : Node
@export var _enemy_area3 : Node
@export var _enemy_area4 : Node
@export var _enemy_area5 : Node

@export var _game_enemy_area2 : Node
@export var _game_enemy_area3 : Node
@export var _game_enemy_area4 : Node
@export var _game_enemy_area5 : Node

# ------- loading -------

@export var _loading_material : Material

# ------- main_ui -------
@export var _label_game_title : Label
@export var _button_start_game : Button
@export var _button_help : Button
@export var _button_credits : Button
@export var _button_achievement : Button
@export var _button_end_game : Button

@export var _button_close_help : Button
@export var _button_close_credits : Button
@export var _button_close_achievement : Button

@export var _button_check_language : CheckButton

# ------- game_ui -------
@export var _label_setting_menu_title : Label
@export var _button_setting_menu_continue : Button
@export var _button_setting_menu_restart : Button
@export var _button_setting_menu_back_nenu : Button

@export var _button_settle_back_nenu : Button



@export var _label_game_enemy_name : Label
@export var _label_game_enemy_description : Label

@export var _panel_thx : Control
@export var _panel_help : Control
@export var _panel_ach : Control

@export var _rich_text_credits : RichTextLabel
@export var _rich_text_help : RichTextLabel
@export var _rich_text_ach : RichTextLabel

@export var _label_version : Label

@export var current_level : int = 1

var player_game_data : Dictionary = {
	"record": {
		"max_level": 0,
		"max_score": 0,
		"max_combo1": 0,
		"max_combo2": 0,
		"max_combo3": 0,
		"max_combo4": 0,
		"max_combo5": 0,
	},
	"achievement": {
		"opengame": false,
		
		"clear_level1": false,
		"clear_level2": false,
		"clear_level3": false,
		"clear_level4": false,
		"clear_level5": false,
		
		"fc_level1": false,
		"fc_level2": false,
		"fc_level3": false,
		"fc_level4": false,
		"fc_level5": false,
		
		"max_score_160": false,
		"max_score_266": false,
		"max_score_399": false,
		"max_score_420": false,
		"max_score_768": false,
	}
}


func _ready() -> void:
	_label_version.text = Const.version
	_upload_locale_text()
	
	_load_player_game_data()
	_show_enemy_info()
	await _end_loading()

func _show_enemy_info() -> void:
	_label_enemy_name.text =tr(Const.level_config[current_level]["enemy_name"])
	_label_enemy_description.text = tr(Const.level_config[current_level]["enemy_description"])
	_enemy_health_container.reset_health_item(Const.level_config[current_level]["enemy_health"])
	_label_game_enemy_name.text = tr(Const.level_config[current_level]["enemy_name"])
	_label_game_enemy_description.text = tr(Const.level_config[current_level]["enemy_description"])
	
	_enemy_area2.visible = false
	_enemy_area3.visible = false
	_enemy_area4.visible = false
	_enemy_area5.visible = false
	_game_enemy_area2.visible = false
	_game_enemy_area3.visible = false
	_game_enemy_area4.visible = false
	_game_enemy_area5.visible = false
	
	if current_level == 2:
		_enemy_area2.visible = true
		_game_enemy_area2.visible = true
	if current_level == 3:
		_enemy_area3.visible = true
		_game_enemy_area3.visible = true
	if current_level == 4:
		_enemy_area4.visible = true
		_game_enemy_area4.visible = true
	if current_level == 5:
		_enemy_area5.visible = true
		_game_enemy_area5.visible = true
	
	_button_last.visible = true
	_button_next.visible = true
	if (current_level == 1):
		_button_last.visible = false
	if (current_level == Const.level_num || current_level > player_game_data["record"]["max_level"]):
		_button_next.visible = false

func _load_player_game_data():
	if FileAccess.file_exists("user://player_game_data.json"):
		var save_file = FileAccess.open("user://player_game_data.json", FileAccess.READ)
		while save_file.get_position() < save_file.get_length():
			var json_string = save_file.get_line()

			# Creates the helper class to interact with JSON.
			var json = JSON.new()

			# Check if there is any error while parsing the JSON string, skip in case of failure.
			var parse_result = json.parse(json_string)
			if not parse_result == OK:
				print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
				continue

			# Get the data from the JSON object.
			player_game_data = json.data
			
			unlock_achievement()
			
	else:
		_save_player_game_data()
		
	
func _save_player_game_data():
	var save_file = FileAccess.open("user://player_game_data.json", FileAccess.WRITE)
	var json_string = JSON.stringify(player_game_data)
	save_file.store_line(json_string)

func unlock_achievement():
	player_game_data["achievement"]["opengame"] = true
	
	if player_game_data["record"]["max_level"] >= 1:
		player_game_data["achievement"]["clear_level1"] = true
	if player_game_data["record"]["max_level"] >= 2:
		player_game_data["achievement"]["clear_level2"] = true
	if player_game_data["record"]["max_level"] >= 3:
		player_game_data["achievement"]["clear_level3"] = true
	if player_game_data["record"]["max_level"] >= 4:
		player_game_data["achievement"]["clear_level4"] = true
	if player_game_data["record"]["max_level"] >= 5:
		player_game_data["achievement"]["clear_level5"] = true

	if player_game_data["record"]["max_combo1"] == Const.level_config[1]["enemy_health"]:
		player_game_data["achievement"]["fc_level1"] = true
	if player_game_data["record"]["max_combo2"] == Const.level_config[2]["enemy_health"]:
		player_game_data["achievement"]["fc_level2"] = true
	if player_game_data["record"]["max_combo3"] == Const.level_config[3]["enemy_health"]:
		player_game_data["achievement"]["fc_level3"] = true
	if player_game_data["record"]["max_combo4"] == Const.level_config[4]["enemy_health"]:
		player_game_data["achievement"]["fc_level4"] = true
	if player_game_data["record"]["max_combo5"] == Const.level_config[5]["enemy_health"]:
		player_game_data["achievement"]["fc_level5"] = true
	
	if player_game_data["record"]["max_score"] >= 160:
		player_game_data["achievement"]["max_score_160"] = true
	if player_game_data["record"]["max_score"] >= 266:
		player_game_data["achievement"]["max_score_266"] = true
	if player_game_data["record"]["max_score"] >= 399:
		player_game_data["achievement"]["max_score_399"] = true
	if player_game_data["record"]["max_score"] >= 420:
		player_game_data["achievement"]["max_score_420"] = true
	if player_game_data["record"]["max_score"] >= 768:
		player_game_data["achievement"]["max_score_768"] = true
	

func _get_current_level() -> int:
	return current_level

func _change_current_level(isAdd : bool) -> void:
	if (isAdd):
		current_level = current_level + 1
	else:
		current_level = current_level - 1

	current_level = clamp(current_level, 1, min(Const.level_num, player_game_data["record"]["max_level"] + 1))


func _on_button_start_pressed() -> void:
	#queue_manager._on_back_menu()
	queue_manager.audio_stream_player.stop()
	await _begin_loading()
	self.visible = false
	queue_manager._on_start_level(current_level)
	await _end_loading()
	


func _on_button_exit_pressed() -> void:
	get_tree().quit()


func _on_button_thx_pressed() -> void:
	_rich_text_credits.text = tr("credits_content")
	_panel_thx.visible = true

func _on_thx_button_close_pressed() -> void:
	_panel_thx.visible = false


func _on_button_help_pressed() -> void:
	_rich_text_help.text = tr("help_content")
	_panel_help.visible = true


func _on_help_button_close_pressed() -> void:
	_panel_help.visible = false


func _on_panel_settle_continue_requested() -> void:
	queue_manager.audio_stream_player.stop()
	await _begin_loading()
	self.visible = false
	_show_enemy_info()
	queue_manager._on_start_level(current_level)
	await _end_loading()


func _on_panel_settle_menu_requested() -> void:
	queue_manager.audio_stream_player.stop()
	await _begin_loading()
	queue_manager._on_back_menu()
	await _end_loading()


func _on_panel_settle_retry_requested() -> void:
	queue_manager.audio_stream_player.stop()
	await _begin_loading()
	self.visible = false
	queue_manager._on_start_level(current_level)
	await _end_loading()


func _on_button_last_pressed() -> void:
	_change_current_level(false)
	_show_enemy_info()


func _on_button_next_pressed() -> void:
	_change_current_level(true)
	_show_enemy_info()

func _getachievement_bbcode() -> String:
	return tr("achievement_content") % [
	# Record部分
	_get_level_name(player_game_data["record"]["max_level"]),
	player_game_data["record"]["max_score"],
	player_game_data["record"]["max_combo1"], player_game_data["record"]["max_combo2"],
	player_game_data["record"]["max_combo3"], player_game_data["record"]["max_combo4"], player_game_data["record"]["max_combo5"],
	
	# Achievement部分
	_get_icon(player_game_data["achievement"]["opengame"]),
	_get_icon(player_game_data["achievement"]["clear_level1"]),
	_get_icon(player_game_data["achievement"]["clear_level2"]),
	_get_icon(player_game_data["achievement"]["clear_level3"]),
	_get_icon(player_game_data["achievement"]["clear_level4"]),
	_get_icon(player_game_data["achievement"]["clear_level5"]),
	
	_get_icon(player_game_data["achievement"]["fc_level1"]),
	_get_icon(player_game_data["achievement"]["fc_level2"]),
	_get_icon(player_game_data["achievement"]["fc_level3"]),
	_get_icon(player_game_data["achievement"]["fc_level4"]), 
	_get_icon(player_game_data["achievement"]["fc_level5"]),
	
	_get_icon(player_game_data["achievement"]["max_score_160"]),
	_get_icon(player_game_data["achievement"]["max_score_266"]),
	_get_icon(player_game_data["achievement"]["max_score_399"]),
	_get_icon(player_game_data["achievement"]["max_score_420"]),
	_get_icon(player_game_data["achievement"]["max_score_768"])]

func _on_button_ach_pressed() -> void:
	var achievement_bbcode = _getachievement_bbcode()
	_rich_text_ach.text = achievement_bbcode
	_panel_ach.visible = true


func _on_ach_button_close_pressed() -> void:
	_panel_ach.visible = false

# 成就状态图标生成函数
func _get_icon(unlocked: bool) -> String:
	return "[color=#00FF00]√[/color]" if unlocked else "[color=#888888]×[/color]"

func _get_level_name(level: int) -> String:
	if !Const.level_config.has(level):
		return tr("mo_record")
	
	return tr(Const.level_config[level]["enemy_name"])

func _on_button_check_language_toggled(toggled_on: bool) -> void:
	if toggled_on:
		TranslationServer.set_locale("en")
	else:
		TranslationServer.set_locale("zh_CN")

	_upload_locale_text()
	_show_enemy_info()
		

func _upload_locale_text():
	_label_game_title.text = tr("game_title")
	_button_start_game.text = tr("start_game")
	_button_help.text = tr("help")
	_button_credits.text = tr("credits")
	_button_achievement.text = tr("achievement")
	_button_end_game.text = tr("end_game")
	
	_button_close_help.text = tr("close")
	_button_close_credits.text = tr("close")
	_button_close_achievement.text = tr("close")
	
	_button_check_language.text = tr("language") + "  "
	
	_label_setting_menu_title.text = tr("setting")
	_button_setting_menu_continue.text = tr("continue")
	_button_setting_menu_restart.text = tr("restart")
	_button_setting_menu_back_nenu.text = tr("back_menu")
	_button_settle_back_nenu.text = tr("back_menu")
	
	_rich_text_help.text = tr("help_content")
	_rich_text_credits.text = tr("credits_content")
	_rich_text_ach.text = _getachievement_bbcode()
	
func _begin_loading() -> void:
	var tween = create_tween()
	tween.tween_method(update_loading_radius, 0.6, 0.0, 0.6)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished

func _end_loading() -> void:
	var tween = create_tween()
	tween.tween_method(update_loading_radius, 0.0, 0.6, 1)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished

func update_loading_radius(new_radius: float):
	_loading_material.set_shader_parameter("radius", new_radius)
