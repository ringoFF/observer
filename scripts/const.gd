extends Node

const version = "v0.2.3"

enum ItemType { None, Top, Left, Front }

const level_num: int = 5

const level_config: Dictionary = {
	1: {
		"level": 1,
		"enemy_name": "enemy_1_name",
		"enemy_description": "enemy_1_descripttion",
		"enemy_health": 5,
		"bpm": 70,
		"audio_stream_index": 1,
		"cell_item_count": 30,
		"cell_items": 
		{
			3:1, 5:1, 8:2, 11:1, 14:2, 17:1, 20:2, 23:1, 26:2, 29:1
		}
	},
	2: {
		"level": 2,
		"enemy_name": "enemy_2_name",
		"enemy_description": "enemy_2_descripttion",
		"enemy_health": 6,
		"bpm": 140,
		"audio_stream_index": 1,
		"cell_item_count": 50,
		"cell_items": 
		{
			2:2, 5:1, 8:2, 11:1, 14:2, 17:2, 20:1, 23:2, 26:2, 29:1, 32:2, 35:1, 38:2, 41:1, 44:2
		}
	},
	3: {
		"level": 3,
		"enemy_name": "enemy_3_name",
		"enemy_description": "enemy_3_descripttion",
		"enemy_health": 7,
		"bpm": 70,
		"audio_stream_index": 2,
		"cell_item_count": 50,
		"cell_items": 
		{
			2:1, 5:3, 8:2, 10:3, 12:1, 13:2, 14:1, 16:2, 17:3, 18:1, 20:2, 23:1,
			26:3, 29:2, 32:1, 35:3, 38:2, 41:3, 44:1
		},
		"change_bpm":
		{
			8: 140,
			20: 70,
			32: 140,
			38: 70
		}
	},
	4: {
		"level": 4,
		"enemy_name": "enemy_4_name",
		"enemy_description": "enemy_4_descripttion",
		"enemy_health": 7,
		"bpm": 70,
		"audio_stream_index": 2,
		"cell_item_count": 30,
		"cell_items": 
		{
			1:3, 3:2, 6:3, 8:2, 9:3, 10:1, 11:2, 12:3, 15:2,
			18:3, 20:2, 21:3, 22:1, 23:2, 24:3, 26:2, 28:1
		},
		"hide_cell":
		{
			6: 12,
			18: 24
		}
	},
	5: {
		"level": 5,
		"enemy_name": "enemy_5_name",
		"enemy_description": "enemy_5_descripttion",
		"enemy_health": 9,
		"bpm": 140,
		"audio_stream_index": 3,
		"cell_item_count": 25,
		"cell_items": 
		{
			1:3, 2:2, 4:1, 5:3, 7:2, 8:1, 10:3,
			11:2, 13:1, 14:3, 16:2,
			17:1, 19:3, 20:2, 22:1
		},
		"change_bpm":
		{
			5: 70,
			10: 140,
			17: 70,
			22: 140
		},
		"hide_cell":
		{
			5: 9,
			17: 20
		}
	},
}
