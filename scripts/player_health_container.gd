extends HBoxContainer
class_name PlayerHealthContainer

var items = []

@export var health_num : int

func reset_health_item() -> void:
	for i in items:
		remove_child(i)

	items.clear()
	
	for i in health_num:
		var new_item = preload("res://scenes/health_item.tscn").instantiate()
		add_child(new_item)
		items.append(new_item)

func _ready() -> void:
	for i in health_num:
		var new_item = preload("res://scenes/health_item.tscn").instantiate()
		add_child(new_item)
		items.append(new_item)
#5 3 [3 - 1] - [5 - 1] 2 0 1 2
func health_down(current_health: int):
	for i in health_num - current_health:
		items[current_health + i].health_down()
	
