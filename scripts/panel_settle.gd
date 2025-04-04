extends Panel
class_name PanelSettle

signal retry_requested
signal continue_requested
signal menu_requested

@export var main_ui : MainUI

@onready var title_label = $TitleLabel
@onready var action_btn = $ButtonGroup/ActionButton

func _ready():
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.1, 0.9)
	add_theme_stylebox_override("panel", style)
	
		

# 设置结算状态
func set_result(is_victory: bool, enemy: String, score: int, maxcombo: int, health: int):
	title_label.text = tr("victory") if is_victory else tr("defeat")
	$DetailBox/EnemyLabel.text = enemy
	$DetailBox/ScoreLabel.text = "%s %d" % [tr("score"),score]
	$DetailBox/ComboLabel.text = "%s %d" % [tr("max_combo"),maxcombo]
	$DetailBox/HealthInfo._show(health)
	action_btn.text = tr("continue") if is_victory else tr("restart")
	
	# 根据状态改变标题颜色
	if !is_victory:
		title_label.add_theme_color_override("font_color", Color.RED)
		
	if is_victory:
		main_ui._change_current_level(true)
	
	self.visible = true

# 按钮信号处理
func _on_action_btn_pressed():
	if action_btn.text == tr("continue"):
		emit_signal("continue_requested")
	else:
		emit_signal("retry_requested")

func _on_menu_btn_pressed():
	emit_signal("menu_requested")
