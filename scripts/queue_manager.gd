# QueueManager.gd
class_name QueueManager
extends Node2D
var cells = []
var bpm : int = 17.5 # 初始BPM对应间隔时间
var is_moving = false
var queueitemindex : int = 0
var queuelen :int = 20
var offsetnum : int = 13
var offsetindex : int = queuelen - offsetnum
var score : int = 0
var maxcombo : int = 0
var combo : int = 0

var show_cell_id : int

var isMainScene : bool = true

@export var current_player_health : int
@export var current_enemy_health : int

@export var audio_stream_player : AudioStreamPlayer
@export var panel_settle : PanelSettle
@export var panel_menu : PanelMenu
@export var player : Player
@export var game_ui : Control
@export var main_ui : MainUI
@export var hide_mask : Sprite2D
@export var playlist : AudioStreamPlaylist

@export var count_down_anim : AnimationPlayer
@export var count_down_area : TextureRect

@export var score_label : Label
@export var combo_label : Label

@export var level : int = 1

var level_config = Const.level_config
var spawn_point_position : Vector2

func _reset_level():
	score = 0
	maxcombo = 0
	combo = 0
	current_player_health = 3
	panel_settle.visible = false
	is_moving = false
	combo_label.text = "%s %d" % [tr("combo"), combo]
	score_label.text = "%s %d" % [tr("score"), score]
	show_cell_id = -1
	hide_mask.visible = false
	
	for i in queuelen:
		cells[i].position = spawn_point_position + Vector2(i * 100 - 200, 0)
		cells[i].move_sprite1()

	$Container.position = Vector2.ZERO
	queueitemindex = 0


func _ready():
	player.visible = false
	game_ui.visible = false
	spawn_point_position = $SpawnPoint.position
	init_queue()


func _on_back_menu():
	player.visible = false
	game_ui.visible = false
	_reset_level()
	audio_stream_player.stop()
	isMainScene = true
	main_ui.visible = true
	main_ui._show_enemy_info()

	for item in cells:
		item.set_cell_item(item.Id, Const.ItemType.None)
	
	on_timer_start()
	
	audio_stream_player.set_stream(playlist.get_list_stream(0))
	audio_stream_player.play()
 
	
var is_starting_level : bool = true

func _on_start_level(_level : int):
	is_starting_level = true
	level = _level

	bpm = level_config[level]["bpm"]
	$Timer.wait_time = 60.0 / bpm # 将BPM转换为秒数

	$Timer.stop()

	for i in cells:
		$Container.remove_child(i)

	cells.clear()

	for i in queuelen:
		var new_cell = preload("res://scenes/cell.tscn").instantiate()
		new_cell.position = spawn_point_position + Vector2(i * 100 - 200, 0)
		$Container.add_child(new_cell)
		cells.append(new_cell)

	queueitemindex = 0

	var currentindex = (queueitemindex + offsetindex )% queuelen
	for i in queuelen - offsetindex:
		var item_type = Const.ItemType.None
		
		if level_config[level]["cell_items"].has(i % level_config[level]["cell_item_count"]) && i > 2:
			item_type = level_config[level]["cell_items"][i % level_config[level]["cell_item_count"]] as Const.ItemType

		
		cells[(i + offsetindex) % (queuelen)].set_cell_item(i, item_type)

	current_player_health = 3
	current_enemy_health = level_config[level]["enemy_health"]
	
	player._on_set_player()
	player._on_set_enemy(current_enemy_health)
	player.visible = true
	game_ui.visible = true
	_reset_level()
	audio_stream_player.stop()
	isMainScene = false
	
	count_down_area.visible = true
	count_down_anim.play("game_start")
	await count_down_anim.animation_finished
	count_down_area.visible = false

	on_timer_start()

	audio_stream_player.set_stream(playlist.get_list_stream(level_config[level]["audio_stream_index"]))
	audio_stream_player.play()
	
	is_starting_level = false
	

func init_queue():
	for i in queuelen:
		var new_cell = preload("res://scenes/cell.tscn").instantiate()
		new_cell.position = spawn_point_position + Vector2(i * 100 - 200, 0)
		$Container.add_child(new_cell)
		cells.append(new_cell)

	on_timer_start()
	
	audio_stream_player.stop()
	audio_stream_player.set_stream(playlist.get_list_stream(0))
	audio_stream_player.play()

func _on_timer_timeout():
	move_queue()

func on_timer_start():
	var currentindex = (queueitemindex + offsetindex )% queuelen
	if !isMainScene:
		GameEvents.emit_signal("before_event", cells[currentindex])
	$Timer.start()

func judge_combo(iscombo : bool):
	if iscombo:
		combo = combo + 1
	else:
		combo = 0

	maxcombo = max(maxcombo, combo)

	combo_label.text = "%s %d" % [tr("combo"), combo]
	
func change_score():
	var smooth_level = max(pow(level_config[level]["level"], 0.5), 1)
	var weight_combo = pow(combo, 2)
	score += smooth_level * 10 + weight_combo * 2

	#print(score)
	
	score_label.text = "%s %d" % [tr("score"), score]

func change_bpm(newbpm: int):
	bpm = newbpm
	$Timer.wait_time = 60.0 / bpm # 将BPM转换为秒数

func hide_cell(_show_cell_id: int):
	show_cell_id = _show_cell_id
	hide_mask.visible = true

func show_cell():
	var currentindex = (queueitemindex + offsetindex )% queuelen
	var curid = cells[currentindex].Id

	if show_cell_id == curid:
		show_cell_id = -1
		hide_mask.visible = false

func show_menu():
	if !panel_menu.visible:
		panel_menu.show_menu(tr(level_config[level]["enemy_name"]), score, maxcombo)
	else:
		panel_menu.recovey_menu()

func move_queue():
	if isMainScene:
		is_moving = true
		# 使用Tween实现顿挫感移动（参考网页7动画实现）
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property($Container, "position", $Container.position + Vector2(-100, 0), 0.1)
		await tween.finished
		is_moving = false
		cells[queueitemindex].position = cells[(queueitemindex - 1) % queuelen].position + Vector2(100, 0)
		
		queueitemindex = (queueitemindex + 1) % queuelen
		
		on_timer_start()

	else:
		var currentindex = (queueitemindex + offsetindex )% queuelen
		var lastid = cells[(queueitemindex - 1) % queuelen].Id
		
		is_moving = true
		GameEvents.emit_signal("after_event", cells[currentindex])
		
		if current_player_health <= 0:
			panel_settle.set_result(false, tr(level_config[level]["enemy_name"]), score, maxcombo, current_player_health)
			$Timer.stop()

			main_ui.player_game_data["record"]["max_score"] = max(score, main_ui.player_game_data["record"]["max_score"])
			if level == 1:
				main_ui.player_game_data["record"]["max_combo1"] = max(combo, main_ui.player_game_data["record"]["max_combo1"])
			if level == 2:
				main_ui.player_game_data["record"]["max_combo2"] = max(combo, main_ui.player_game_data["record"]["max_combo2"])
			if level == 3:
				main_ui.player_game_data["record"]["max_combo3"] = max(combo, main_ui.player_game_data["record"]["max_combo3"])
			if level == 4:
				main_ui.player_game_data["record"]["max_combo4"] = max(combo, main_ui.player_game_data["record"]["max_combo4"])
			if level == 5:
				main_ui.player_game_data["record"]["max_combo5"] = max(combo, main_ui.player_game_data["record"]["max_combo5"])

			main_ui.unlock_achievement()
			main_ui._save_player_game_data()
			return

		if current_enemy_health <= 0:
			panel_settle.set_result(true, tr(level_config[level]["enemy_name"]), score, maxcombo, current_player_health)
			$Timer.stop()
			
			main_ui.player_game_data["record"]["max_level"] = max(level, main_ui.player_game_data["record"]["max_level"])
			main_ui.player_game_data["record"]["max_score"] = max(score, main_ui.player_game_data["record"]["max_score"])
			if level == 1:
				main_ui.player_game_data["record"]["max_combo1"] = max(combo, main_ui.player_game_data["record"]["max_combo1"])
			if level == 2:
				main_ui.player_game_data["record"]["max_combo2"] = max(combo, main_ui.player_game_data["record"]["max_combo2"])
			if level == 3:
				main_ui.player_game_data["record"]["max_combo3"] = max(combo, main_ui.player_game_data["record"]["max_combo3"])
			if level == 4:
				main_ui.player_game_data["record"]["max_combo4"] = max(combo, main_ui.player_game_data["record"]["max_combo4"])
			if level == 5:
				main_ui.player_game_data["record"]["max_combo5"] = max(combo, main_ui.player_game_data["record"]["max_combo5"])

			main_ui.unlock_achievement()
			main_ui._save_player_game_data()
			return
		
		# 使用Tween实现顿挫感移动（参考网页7动画实现）
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property($Container, "position", $Container.position + Vector2(-100, 0), 0.1)
		await tween.finished
		is_moving = false

		cells[queueitemindex].position = cells[(queueitemindex - 1) % queuelen].position + Vector2(100, 0)

		var item_type = Const.ItemType.None
		if level_config[level]["cell_items"].has((lastid + 1) % level_config[level]["cell_item_count"]):
			item_type = level_config[level]["cell_items"][(lastid + 1) % level_config[level]["cell_item_count"]] as Const.ItemType

		cells[queueitemindex].set_cell_item(lastid + 1, item_type)
		
		queueitemindex = (queueitemindex + 1) % queuelen
		
		on_timer_start()
