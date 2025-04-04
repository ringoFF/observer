class_name Cell
extends Area2D
@export var item_type: Const.ItemType = Const.ItemType.None
@export var Id: int = 0
@export var animated_sprite_2d: AnimatedSprite2D

var pos : Vector2

func _ready() -> void:
	pos = $Board.position

func set_cell_item(id: int, itemtype: Const.ItemType):
	Id = id
	item_type = itemtype
	
	match item_type:
		Const.ItemType.Top:
			animated_sprite_2d.play("top")
		Const.ItemType.Left:
			animated_sprite_2d.play("left")
		Const.ItemType.Front:
			animated_sprite_2d.play("front")
		Const.ItemType.None:
			animated_sprite_2d.play("default")

func move_sprite():
	$Board.position += Vector2(0, -10)
	
func move_sprite1():
	$Board.position = pos

func to_attack():
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($Enemy, "position:y", -50, 0.1)
	tween.chain().tween_property($Enemy, "position:y", 0, 0.1)
	
