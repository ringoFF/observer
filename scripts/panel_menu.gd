extends Panel
class_name PanelMenu

signal retry_requested
signal menu_requested

@export var main_ui : MainUI
@export var queue_manager : QueueManager

func _ready():
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.1, 0.9)
	add_theme_stylebox_override("panel", style)

func _physics_process(delta: float) -> void:
	if !main_ui.queue_manager.isMainScene:
		if !queue_manager.is_starting_level:
			if Input.is_action_just_pressed("esc"):
				main_ui.queue_manager.show_menu()

func recovey_menu():
	get_tree().paused = false
	self.visible = false

# 设置结算状态
func show_menu(enemy: String, score: int, maxcombo: int):
	$DetailBox/EnemyLabel.text = enemy
	$DetailBox/ScoreLabel.text = "%s %d" % [tr("score"),score]
	$DetailBox/ComboLabel.text = "%s %d" % [tr("max_combo"),maxcombo]
	
	get_tree().paused = true
	self.visible = true

# 按钮信号处理
func _on_continue_btn_pressed():
	recovey_menu()

func _on_restart_btn_pressed():
	recovey_menu()
	emit_signal("retry_requested")

func _on_menu_btn_pressed():
	recovey_menu()
	emit_signal("menu_requested")
