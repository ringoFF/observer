extends Control

class_name PanelKeyprompt

@export var top : CanvasItem
@export var left : CanvasItem
@export var front : CanvasItem

@export var eyes_top : CanvasItem
@export var eyes_left : CanvasItem
@export var eyes_front : CanvasItem

@export var west : CanvasItem
@export var east : CanvasItem
@export var north : CanvasItem
@export var south : CanvasItem

@export var texture_saber : Texture2D
@export var texture_knight : Texture2D
@export var texture_caster : Texture2D

@export var rect_1 : TextureRect
@export var rect_2 : TextureRect
@export var rect_3 : TextureRect

func change_view(is_top : bool, is_front : bool):
	north.visible = !is_top
	south.visible = is_top
	west.visible = !is_front
	east.visible = is_front
	
	match get_item_type(is_top, is_front):
		Const.ItemType.Top:
			top.z_index = 10
			left.z_index = 8
			front.z_index = 8
			
			eyes_top.visible = true
			eyes_left.visible = false
			eyes_front.visible = false
			
			rect_2.texture = texture_caster
			rect_1.texture = texture_saber
			rect_3.texture = texture_knight
			
		Const.ItemType.Left:
			top.z_index = 8
			left.z_index = 10
			front.z_index = 8
			
			eyes_top.visible = false
			eyes_left.visible = true
			eyes_front.visible = false
			
			rect_2.texture = texture_saber
			rect_1.texture = texture_knight
			rect_3.texture = texture_caster
			
		Const.ItemType.Front:
			top.z_index = 8
			left.z_index = 8
			front.z_index = 10
			
			eyes_top.visible = false
			eyes_left.visible = false
			eyes_front.visible = true
			
			rect_2.texture = texture_knight
			rect_1.texture = texture_caster
			rect_3.texture = texture_saber

func get_item_type(is_top : bool, is_front : bool) -> Const.ItemType:
	if is_top:
		return Const.ItemType.Top
	else:
		if is_front:
			return Const.ItemType.Front
		else:
			return Const.ItemType.Left
