extends Node2D
class_name Player

@export var isTop : bool = false
@export var isFront : bool = true

@export var animated_sprite_2d: AnimatedSprite2D
@export var queue_manager : QueueManager

@export var player_health_container : PlayerHealthContainer
@export var enemy_health_container : EnemyHealthContainer
@export var panel_keyprompt : PanelKeyprompt

# 在组件脚本中
func _ready():
	GameEvents.connect("before_event", _on_before_event)
	GameEvents.connect("after_event", _on_after_event)
	change_keyprompt()
	playanim()

func _exit_tree():
	GameEvents.disconnect("before_event", _on_before_event)
	GameEvents.disconnect("after_event", _on_after_event)

#_change_current_level
func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("toggle_h"):
		if isTop:
			isTop = false
			if Input.is_action_just_pressed("press_left"):
				isFront = true
			else:
				isFront = false
			
		else:
			isFront = !isFront
		
		change_keyprompt()
		playanim()

	if Input.is_action_just_pressed("toggle_v"):
		isTop = !isTop
		change_keyprompt()
		playanim()

func change_keyprompt():
	panel_keyprompt.change_view(isTop, isFront)

func playanim():
	match get_item_type():
		Const.ItemType.Top:
			animated_sprite_2d.play("top")
		Const.ItemType.Left:
			animated_sprite_2d.play("left")
		Const.ItemType.Front:
			animated_sprite_2d.play("front")
		Const.ItemType.None:
			pass

func get_item_type() -> Const.ItemType:
	if isTop:
		return Const.ItemType.Top
	else:
		if isFront:
			return Const.ItemType.Front
		else:
			return Const.ItemType.Left
	
func _on_set_player():
	player_health_container.reset_health_item()

func _on_set_enemy(health : int):
	enemy_health_container.reset_health_item(health)

func to_attcck():
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($AnimatedSprite2D, "position", Vector2(10, 10), 0.1)
	tween.chain().tween_property($AnimatedSprite2D, "position", Vector2(0, 0), 0.1)

# top   杖
# left  剑
# front 盾
# t > f
# f > l
# l > t

func _on_before_event(cell):
	cell.move_sprite()
	queue_manager.show_cell()
	
	var player_type = get_item_type()
	var enemy_type = cell.item_type
	
	if enemy_type == Const.ItemType.None:
		pass
	elif player_type == enemy_type:
		pass
	else:
		if (player_type == Const.ItemType.Top && enemy_type == Const.ItemType.Front) || \
			(player_type == Const.ItemType.Front && enemy_type == Const.ItemType.Left) || \
			(player_type == Const.ItemType.Left && enemy_type == Const.ItemType.Top):
			#print("ememy - 1 血量")
			to_attcck()
			queue_manager.current_enemy_health = queue_manager.current_enemy_health - 1
			queue_manager.current_enemy_health = max(queue_manager.current_enemy_health, 0)
			enemy_health_container.health_down(queue_manager.current_enemy_health)
			queue_manager.judge_combo(true)
			queue_manager.change_score()
		else:
			#print("player - 1 血量")
			cell.to_attack()
			queue_manager.current_player_health = queue_manager.current_player_health - 1
			queue_manager.current_player_health = max(queue_manager.current_player_health, 0)
			player_health_container.health_down(queue_manager.current_player_health)
			queue_manager.judge_combo(false)


func _on_after_event(cell):
	cell.move_sprite1()

	var level = queue_manager.level
	if Const.level_config[level].has("change_bpm"):
		if Const.level_config[level]["change_bpm"].has(cell.Id % Const.level_config[level]["cell_item_count"]):
			queue_manager.change_bpm(Const.level_config[level]["change_bpm"][cell.Id % Const.level_config[level]["cell_item_count"]])

	if Const.level_config[level].has("hide_cell"):
		if Const.level_config[level]["hide_cell"].has(cell.Id % Const.level_config[level]["cell_item_count"]):
			queue_manager.hide_cell(Const.level_config[level]["hide_cell"][cell.Id % Const.level_config[level]["cell_item_count"]])

	#pass
