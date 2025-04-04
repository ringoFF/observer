extends PanelContainer
class_name HealthItem

@export var FillHealth : CanvasItem
@export var animation_player : AnimationPlayer

var isDown : bool = false

func _reset_item():
	FillHealth.visible = true
	isDown = false

func health_down():
	if !isDown:
		isDown = true
		animation_player.play("health_down")
		await animation_player.animation_finished
		FillHealth.visible = false

#func change_size(size: int):
	
