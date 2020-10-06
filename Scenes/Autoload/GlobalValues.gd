extends Node


var window_size 
var stage_height = 324
var bottom_height = 80
var control_height 
var stage_size
var bottom_size
var control_size
var control_position
var control_plus_bottom_size
var static_window_size

func _ready():
	window_size = get_viewport().size
	static_window_size = Vector2(576,1024)
	control_height = static_window_size.y - stage_height - bottom_height
	stage_size = Vector2(window_size.x,stage_height)
	control_size = Vector2(window_size.x,control_height)
	bottom_size = Vector2(window_size.x,bottom_height)
	control_position = Vector2(0,stage_height)
	control_plus_bottom_size = Vector2(window_size.x,control_height+bottom_height)
